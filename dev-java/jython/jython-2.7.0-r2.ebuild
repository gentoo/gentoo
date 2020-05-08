# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2 python-utils-r1 flag-o-matic

MY_PV=${PV/_beta/-b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="An implementation of Python written in Java"
HOMEPAGE="https://www.jython.org"
SRC_URI="https://search.maven.org/remotecontent?filepath=org/python/${PN}/${MY_PV}/${MY_P}-sources.jar"

LICENSE="PSF-2"
SLOT="2.7"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="examples test"

CP_DEPEND="dev-java/antlr:3
	dev-java/netty-transport:0
	>=dev-java/asm-5:4
	dev-java/commons-compress:0
	dev-java/guava:20
	dev-java/jffi:1.2
	dev-java/jline:2
	dev-java/icu4j:52
	dev-java/jnr-constants:0
	dev-java/jnr-posix:3.0
	dev-java/jnr-netdb:1.0
	dev-java/stringtemplate:0
	dev-java/xerces:2
	java-virtuals/script-api:0
	java-virtuals/servlet-api:3.0"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.7"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.7
	app-arch/unzip
	dev-java/ant-core:0
	test? (
		dev-java/junit:4
		dev-java/ant-junit:0
	)"

S=${WORKDIR}

RESTRICT="test"

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" java"

EANT_BUILD_TARGET="developer-build"
EANT_TEST_EXTRA_ARGS="-Dpython.home=dist"

# jdbc-informix and jdbc-oracle-bin (requires registration) aren't exposed.
# Uncomment and add to CDEPEND if you want either of them
#EANT_GENTOO_CLASSPATH+=",jdbc-informix"   EANT_EXTRA_ARGS+=" -Dinformix.present"
#EANT_GENTOO_CLASSPATH+=",jdbc-oracle-bin" EANT_EXTRA_ARGS+=" -Doracle.present"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.2-distutils_scripts_location.patch
	"${FILESDIR}"/${PN}-2.5.2-respect_PYTHONPATH.patch
	"${FILESDIR}"/${PN}-2.7_beta1-ant.patch
	"${FILESDIR}"/${PN}-2.7_beta1-dont-always-recompile-classes.patch
	"${FILESDIR}"/${PN}-2.7_beta2-maxrepeat-import.patch
	"${FILESDIR}"/${PN}-2.7.0-build.xml.patch
	"${FILESDIR}"/CVE-2016-4000.patch
)

src_prepare() {
	default

	find \( -name '*.jar' -o -name '*.class' \
		-o -name '*.pyc' -o -name '*.exe' \) -delete

	# needed for launchertest
	chmod +x tests/shell/test-jython.sh || die

	java-pkg-2_src_prepare
}

src_configure() {
	# apparently this can cause problems
	append-flags -fno-stack-protector

	EANT_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --with-dependencies antlr-3,jnr-posix-3.0)"
	EANT_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjars --build-only ant-core)"
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	local instdir=/usr/share/${PN}-${SLOT}

	java-pkg_newjar dist/${PN}-dev.jar

	java-pkg_register-optional-dependency jdbc-mysql
	java-pkg_register-optional-dependency jdbc-postgresql

	insinto ${instdir}
	doins -r dist/{Lib,registry}

	dodoc ACKNOWLEDGMENTS NEWS README.txt

	use doc && java-pkg_dohtml -r dist/Doc/javadoc
	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples Demo/*

	local java_args=(
		-Dpython.home="${EPREFIX}"/usr/share/${PN}-${SLOT}
		-Dpython.executable="${EPREFIX}"/usr/bin/jython${SLOT}
		-Dpython.cachedir="\${HOME}/.jythoncachedir"
	)

	java-pkg_dolauncher jython${SLOT} \
		--main org.python.util.jython \
		--java_args "${java_args[*]}"

	# we need a wrapper to help python_optimize
	cat <<-EOF > "${T}"/jython
		exec java -cp "$(java-pkg_getjars "${EANT_GENTOO_CLASSPATH}"):${EANT_GENTOO_CLASSPATH_EXTRA}:dist/${PN}-dev.jar" \
			-Dpython.home="${ED}${instdir}" \
			-Dpython.cachedir="${T}/.jythoncachedir" \
			-Duser.home="${T}" \
			org.python.util.jython "\${@}"
	EOF
	chmod +x "${T}"/jython || die

	local -x PYTHON="${T}"/jython
	# we can't get the path from the interpreter since it does some
	# magic that fails on non-installed copy...
	local PYTHON_SITEDIR=${EPREFIX}/usr/share/jython-${SLOT}/Lib/site-packages
	python_export jython${SLOT} EPYTHON

	# compile tests (everything else is compiled already)
	# we're keeping it quiet since jython reports errors verbosely
	# and some of the tests are supposed to trigger compile errors
	python_optimize "${ED}${instdir}"/Lib/test &>/dev/null

	# for python-exec
	echo "EPYTHON='${EPYTHON}'" > epython.py || die
	python_domodule epython.py

	# some of the class files end up with newer timestamps than the files they
	# were generated from, make sure this doesn't happen
	find "${ED}${instdir}"/Lib/ -name '*.class' | xargs touch
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jython/jython-2.7.0.ebuild,v 1.2 2015/06/13 18:04:56 monsieurp Exp $

EAPI=5
JAVA_PKG_IUSE="doc examples source"

inherit eutils java-pkg-2 java-ant-2 python-utils-r1 flag-o-matic

MY_PV=${PV/_beta/-b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="An implementation of Python written in Java"
HOMEPAGE="http://www.jython.org"
SRC_URI="http://search.maven.org/remotecontent?filepath=org/python/${PN}/${MY_PV}/${MY_P}-sources.jar"

LICENSE="PSF-2"
SLOT="2.7"
KEYWORDS="~amd64 ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="+readline test"
REQUIRED_USE="test? ( readline )"

CDEPEND="dev-java/ant-core:0
	dev-java/antlr:3
	dev-java/netty-transport:0
	=dev-java/asm-5.0.3:4
	dev-java/commons-compress:0
	dev-java/guava:13
	>=dev-java/java-config-2.1.11-r3
	dev-java/jffi:1.2
	dev-java/jline:0
	dev-java/jline:2
	dev-java/icu4j:52
	dev-java/jnr-constants:0
	dev-java/jnr-posix:3.0
	dev-java/jnr-netdb:1.0
	dev-java/stringtemplate:0
	dev-java/xerces:2
	java-virtuals/script-api:0
	java-virtuals/servlet-api:3.0
	readline? ( >=dev-java/libreadline-java-0.8.0:0 )"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.7
	app-arch/unzip
	test? (
		dev-java/junit:4
		dev-java/ant-junit:0
	)"

S=${WORKDIR}

RESTRICT="test"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="asm-4,commons-compress,guava-13,jffi-1.2,jline-2,jnr-constants"
EANT_GENTOO_CLASSPATH+=",script-api,servlet-api-3.0,stringtemplate,xerces-2"
EANT_GENTOO_CLASSPATH+=",icu4j-52,netty-transport,jnr-posix-3.0"
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
)

java_prepare() {
	find \( -name '*.jar' -o -name '*.class' \
		-o -name '*.pyc' -o -name '*.exe' \) -delete

	epatch "${PATCHES[@]}"

	if ! use readline; then
		rm -v src/org/python/util/ReadlineConsole.java || die
	fi

	# needed for launchertest
	chmod +x tests/shell/test-jython.sh || die

	# apparently this can cause problems
	append-flags -fno-stack-protector
}

src_compile() {
	use readline && EANT_GENTOO_CLASSPATH+=",libreadline-java"

	EANT_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --with-dependencies antlr-3,jnr-posix-3.0)"
	EANT_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjars --build-only ant-core)"

	sed -i -e "1 a\
		CLASSPATH=\"$(java-pkg_getjars "${EANT_GENTOO_CLASSPATH}"):${EANT_GENTOO_CLASSPATH_EXTRA}\"" \
		src/shell/jython || die

	java-pkg-2_src_compile
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

	use doc && java-pkg_dojavadoc dist/Doc/javadoc
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

	if use readline; then
		sed \
			-e "s/#\(python.console=org.python.util.ReadlineConsole\)/\1/" \
			-e "/#python.console.readlinelib=JavaReadline/a python.console.readlinelib=GnuReadline" \
			-i "${ED}"/usr/share/${PN}-${SLOT}/registry || die
	fi

	# we need a wrapper to help python_optimize
	cat <<-EOF > "${T}"/jython
		exec java -cp "$(java-pkg_getjars "${EANT_GENTOO_CLASSPATH}"):${EANT_GENTOO_CLASSPATH_EXTRA}:dist/${PN}-dev.jar" \
			-Dpython.home="${ED}${instdir}" \
			-Dpython.cachedir="${T}/.jythoncachedir" \
			-Duser.home="${T}" \
			org.python.util.jython "\${@}"
	EOF
	chmod +x "${T}"/jython || die

	python_export jython${SLOT} EPYTHON PYTHON_SITEDIR
	local PYTHON="${T}"/jython

	# compile tests (everything else is compiled already)
	# we're keeping it quiet since jython reports errors verbosely
	# and some of the tests are supposed to trigger compile errors
	python_optimize "${ED}${instdir}"/Lib/test &>/dev/null

	# for python-exec
	echo "EPYTHON='${EPYTHON}'" > epython.py
	python_domodule epython.py

	# some of the class files end up with newer timestamps than the files they
	# were generated from, make sure this doesn't happen
	find "${ED}${instdir}"/Lib/ -name '*.class' | xargs touch
}

pkg_postinst() {
	if ! has_version dev-java/jython ; then
		elog
		elog "readline can be configured in the registry:"
		elog
		elog "python.console=org.python.util.ReadlineConsole"
		elog "python.console.readlinelib=GnuReadline"
		elog
		elog "Global registry: '${EROOT}usr/share/${PN}-${SLOT}/registry'"
		elog "User registry: '~/.jython'"
		elog "See http://www.jython.org/docs/registry.html for more information."
		elog
	fi
}

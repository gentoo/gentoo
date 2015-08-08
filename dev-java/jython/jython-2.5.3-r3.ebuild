# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc examples source"

inherit eutils java-pkg-2 java-ant-2 python-utils-r1

DESCRIPTION="An implementation of Python written in Java"
HOMEPAGE="http://www.jython.org"
SRC_URI="http://central.maven.org/maven2/org/python/${PN}-installer/${PV}/${PN}-installer-${PV}.jar"

LICENSE="PSF-2"
SLOT="2.5"
KEYWORDS="amd64 x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="readline"

# Missing in installer jar.
RESTRICT="test"

COMMON_DEP="
	!<=dev-java/freemarker-2.3.10
	dev-java/antlr:3
	dev-java/asm:3
	dev-java/guava:0
	>=dev-java/java-config-2.1.11-r3
	dev-java/jffi:1.0
	dev-java/jline:0
	dev-java/jnr-constants:0.8.2
	dev-java/jnr-posix:1.1
	java-virtuals/script-api:0
	java-virtuals/servlet-api:2.5
	readline? ( >=dev-java/libreadline-java-0.8.0:0 )"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"

java_prepare() {
	# src/META-INF/services missing - taking from prebuilt jar
	pushd src > /dev/null || die
		jar -xf ../${PN}.jar META-INF/services || die
	popd > /dev/null

	find \( -name '*.jar' -o -name '*.class' \
		-o -name '*.pyc' -o -name '*.exe' \) -delete

	epatch "${FILESDIR}/${PN}-2.5.2-build.xml.patch"

	epatch "${FILESDIR}/${PN}-2.5.2-distutils_byte_compilation.patch"
	epatch "${FILESDIR}/${PN}-2.5.2-distutils_scripts_location.patch"
	epatch "${FILESDIR}/${PN}-2.5.2-respect_PYTHONPATH.patch"

	if ! use readline; then
		rm -v src/org/python/util/ReadlineConsole.java || die
	fi
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" java"

EANT_BUILD_TARGET="developer-build"
EANT_GENTOO_CLASSPATH="asm-3,guava,jffi-1.0,jline,jnr-constants-0.8.2,script-api,servlet-api-2.5"

# jdbc-informix and jdbc-oracle-bin (requires registration) aren't exposed.
# Uncomment and add to COMMON_DEP if you want either of them
#EANT_GENTOO_CLASSPATH+=",jdbc-informix"   EANT_EXTRA_ARGS+=" -Dinformix.present"
#EANT_GENTOO_CLASSPATH+=",jdbc-oracle-bin" EANT_EXTRA_ARGS+=" -Doracle.present"

src_compile() {
	use readline && EANT_GENTOO_CLASSPATH+=",libreadline-java"

	EANT_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --with-dependencies antlr-3,jnr-posix-1.1)"
	EANT_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjars --build-only ant-core)"

	sed -i -e "1 a\
		CLASSPATH=\"$(java-pkg_getjars "${EANT_GENTOO_CLASSPATH}"):${EANT_GENTOO_CLASSPATH_EXTRA}\"" \
		bin/jython || die

	java-pkg-2_src_compile
}

EANT_TEST_EXTRA_ARGS="-Dpython.home=dist"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar dist/${PN}-dev.jar

	java-pkg_register-optional-dependency jdbc-mysql
	java-pkg_register-optional-dependency jdbc-postgresql

	insinto /usr/share/${PN}-${SLOT}
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
		sed -i -e "/#python.console.readlinelib=JavaReadline/a \
			python.console=org.python.util.ReadlineConsole\npython.console.readlinelib=GnuReadline" \
			"${ED}"/usr/share/${PN}-${SLOT}/registry || die
	fi

	# the jvm opens classfiles rw ...
	dodir /etc/sandbox.d
	echo "SANDBOX_PREDICT=/usr/share/${PN}-${SLOT}" > "${ED}/etc/sandbox.d/20${P}-${SLOT}"

	# we need a wrapper to help python_optimize
	cat > "${T}"/jython <<_EOF_ || die
exec java -cp "$(java-pkg_getjars "${EANT_GENTOO_CLASSPATH}"):${EANT_GENTOO_CLASSPATH_EXTRA}:dist/${PN}-dev.jar" \
	-Dpython.home="${ED}"/usr/share/${PN}-${SLOT} \
	-Dpython.cachedir="${T}/.jythoncachedir" \
	-Duser.home="${T}" \
	org.python.util.jython "\${@}"
_EOF_
	chmod +x "${T}"/jython || die

	python_export jython${SLOT} EPYTHON PYTHON_SITEDIR
	local PYTHON="${T}"/jython

	# compile tests (everything else is compiled already)
	# we're keeping it quiet since jython reports errors verbosely
	# and some of the tests are supposed to trigger compile errors
	python_optimize "${ED}"/usr/share/jython-${SLOT}/Lib/test &>/dev/null

	# for python-exec
	echo "EPYTHON='${EPYTHON}'" > epython.py
	python_domodule epython.py
}

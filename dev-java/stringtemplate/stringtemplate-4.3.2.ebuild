# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.antlr:ST4:4.3.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java template engine"
HOMEPAGE="https://www.stringtemplate.org/"
# Maven Central sources JAR for *.java sources pre-generated from *.g files;
# the source generation requires antlr-tool-3.5, which depends on this package.
# Tarball for the test suite and DOCS files
SRC_URI="
	https://repo1.maven.org/maven2/org/antlr/ST4/${PV}/ST4-${PV}-sources.jar
	https://github.com/antlr/${PN}4/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

CP_DEPEND="
	dev-java/antlr-runtime:3.5
"

BDEPEND="
	app-arch/unzip
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/antlr-tool:3.5
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}"
TARBALL_S="${S}/${PN}4-${PV}"

JAVA_SRC_DIR="org"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,antlr-tool-3.5"
JAVA_TEST_SRC_DIR="${TARBALL_S}/test"
JAVA_TEST_RESOURCE_DIRS=( "${TARBALL_S}/test/resources" )

DOCS=( "${TARBALL_S}/"{CHANGES.txt,README.md} )

src_prepare() {
	# Do not call java-pkg_clean; otherwise, it would remove
	# ${TARBALL_S}/test/test.jar, which is merely used as a
	# test resource file, does not contain any *.class files,
	# and is required to pass the tests as of version 4.3.2
	pushd "${TARBALL_S}" > /dev/null ||
		die "Failed to enter directory storing tarball contents"
	eapply "${FILESDIR}/${PN}-4.3.1-BaseTest-javac-source-target.patch"
	popd > /dev/null ||
		die "Failed to leave directory storing tarball contents"
	java-pkg-2_src_prepare
	# Some of these tests requires a graphical display.
	rm -v "${JAVA_TEST_SRC_DIR}/org/stringtemplate/v4/test/TestEarlyEvaluation.java" || die
}

src_test() {
	# Make sure no older versions of this slot are present in the classpath
	# https://bugs.gentoo.org/834138#c4
	local old_ver_cp="$(nonfatal java-pkg_getjars "${PN}-${SLOT}")"
	local new_test_cp="$(\
		java-pkg_getjars --with-dependencies "${JAVA_TEST_GENTOO_CLASSPATH}")"
	new_test_cp="${new_test_cp//"${old_ver_cp}"/}"

	# Some of the test cases require an absolute path to the JAR being tested
	# against to be in the classpath, due to the fact that they call the 'java'
	# command outside ${S} and reuse the classpath for the tests:
	# https://github.com/antlr/stringtemplate4/blob/4.3.1/test/org/stringtemplate/v4/test/TestImports.java#L103
	# https://github.com/antlr/stringtemplate4/blob/4.3.1/test/org/stringtemplate/v4/test/BaseTest.java#L174
	new_test_cp="${S}/${JAVA_JAR_FILENAME}:${new_test_cp}"

	# The JAR used as a test resource file needs to be in the classpath
	# https://github.com/antlr/stringtemplate4/blob/4.3.2/pom.xml#L53-L58
	new_test_cp+=":${JAVA_TEST_SRC_DIR}/test.jar"

	# Use JAVA_GENTOO_CLASSPATH_EXTRA to set test classpath
	local JAVA_TEST_GENTOO_CLASSPATH=""
	[[ -n "${JAVA_GENTOO_CLASSPATH_EXTRA}" ]] &&
		JAVA_GENTOO_CLASSPATH_EXTRA+=":"
	JAVA_GENTOO_CLASSPATH_EXTRA+="${new_test_cp}"
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}

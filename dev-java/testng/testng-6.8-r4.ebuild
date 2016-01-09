# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="New generation testing framework in Java"
HOMEPAGE="http://testng.org/"
SRC_URI="http://${PN}.org/${P}.zip"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

CDEPEND="
	dev-java/bsh:0
	dev-java/guice:2
	dev-java/junit:4
	dev-java/ant-core:0
	dev-java/snakeyaml:0
	dev-java/jcommander:0"

DEPEND="
	${CDEPEND}
	app-arch/zip
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

JAVA_ANT_CLASSPATH_TAGS+=" testng javadocs-current"
JAVA_PKG_BSFIX_NAME="build.xml build-tests.xml"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_ENCODING="ISO-8859-1"

EANT_GENTOO_CLASSPATH="ant-core,bsh,guice-2,jcommander,junit-4,snakeyaml-1.9"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH}"

EANT_BUILD_TARGET="build"
EANT_TEST_TARGET="tests"
EANT_DOC_TARGET="javadocs"

PATCHES=(
	"${FILESDIR}"/${P}-remove-ivy-retrieve.patch
	"${FILESDIR}"/${P}-remove-jar-bundling.patch
)

# Error: A JNI error has occurred, please check your installation and try again.
RESTRICT="test"

java_prepare() {
	java-pkg_clean

	cp "${FILESDIR}"/${P}-build-tests.xml build-tests.xml || die

	epatch "${PATCHES[@]}"

	# Removal of tests that break due to restrictions or environment expectations:
	#     ServiceLoaderTest - Breaks due absolute URL load that Portage prevents;
	#                         we assume the underlying functionality to work, as
	#                         the underlying functionality is simple and should
	#                         show the usage of this package to break.
	sed -i '/test.serviceloader.ServiceLoaderTest/d' src/test/resources/testng.xml || die

	#     TrueParallelTest - Doesn't always work, especially not on a system
	#                        under load; since this could fail during parallel
	#                        emerges, we assume the underlying functionality to
	#                        work as it has definitely succeeded under lower load.
	sed -i '/test.thread.TrueParallelTest/d' src/test/resources/testng.xml || die

	mkdir lib || die
}

src_test() {
	java-pkg-2_src_test

	local tests_file="target/test-output/index.html"

	if [[ ! -f ${tests_file} ]] ; then
		die "Tests failed, test output does not exist; a problem with starting the tests."
	fi

	grep 'method-stats.*failed' target/test-output/index.html > /dev/null && \
		die "Tests failed; one or more test failed, see ${tests_file} for more details."
}

src_install() {
	java-pkg_newjar target/${P}.jar
	java-pkg_dolauncher ${PN} --main org.testng.TestNG
	java-pkg_register-ant-task

	use doc && java-pkg_dojavadoc javadocs
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/main/java/{org,com}
}

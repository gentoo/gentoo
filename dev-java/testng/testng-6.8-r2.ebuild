# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/testng/testng-6.8-r2.ebuild,v 1.3 2015/04/02 18:34:23 mr_bones_ Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"
WANT_ANT_TASKS="ant-junit"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Testing framework introducing some new functionalities that make it more powerful and easier to use"
HOMEPAGE="http://testng.org/"
SRC_URI="http://${PN}.org/${P}.zip"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

CDEPEND="dev-java/ant-core:0
	dev-java/bsh:0
	dev-java/guice:2
	dev-java/jcommander:0
	dev-java/junit:4
	dev-java/snakeyaml:1.9"

DEPEND=">=virtual/jdk-1.5
	app-arch/zip
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

JAVA_PKG_BSFIX_NAME="build.xml build-tests.xml"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_CLASSPATH_TAGS+=" testng javadocs-current"
EANT_GENTOO_CLASSPATH="ant-core,bsh,guice-2,jcommander,junit-4,snakeyaml-1.9"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH}"

EANT_BUILD_TARGET="build"
EANT_TEST_TARGET="tests"
EANT_DOC_TARGET="javadocs"

java_prepare() {
	find . -name '*.jar' -print -delete || die

	cp "${FILESDIR}"/${P}-build-tests.xml build-tests.xml || die

	epatch "${FILESDIR}"/${P}-remove-ivy-retrieve.patch
	epatch "${FILESDIR}"/${P}-remove-jar-bundling.patch

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
	local tests_file="target/test-output/index.html"

	java-pkg-2_src_test

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

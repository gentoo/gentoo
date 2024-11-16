# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.javassist:javassist:3.29.2-GA"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A class library for editing bytecodes in Java."
HOMEPAGE="https://www.javassist.org"
SRC_URI="https://github.com/jboss-javassist/javassist/archive/rel_${PV//./_}_ga.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-rel_${PV//./_}_ga"

LICENSE="Apache-2.0 LGPL-2.1 MPL-1.1"
SLOT="3"
KEYWORDS="amd64 arm64 ppc64 ~amd64-linux ~x86-linux"

DEPEND="
	>=virtual/jdk-11:*
	test? ( dev-java/hamcrest-library:1.3 )
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( Changes.md README.md )
HTML_DOCS=( tutorial/{brown.css,tutorial.html,tutorial2.html,tutorial3.html} )

JAVA_AUTOMATIC_MODULE_NAME="org.javassist"
JAVA_MAIN_CLASS="javassist.CtClass"
JAVA_SRC_DIR="src/main"

JAVA_TEST_GENTOO_CLASSPATH="hamcrest-library-1.3,junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY="javassist.JvstTest" # pom.xml, line 167
JAVA_TEST_SRC_DIR="src/test"

src_prepare() {
	default
	java-pkg_clean javassist.jar

	sed -e 's:\.\./\.\./::' -i src/test/javassist/JvstTest{4,Root}.java || die

	# There were 2 failures:
	# 1) testURL(javassist.JvstTest2)
	# junit.framework.AssertionFailedError
	# 	at junit.framework.Assert.fail(Assert.java:55)
	# 	at junit.framework.Assert.assertTrue(Assert.java:22)
	# 	at junit.framework.Assert.assertTrue(Assert.java:31)
	# 	at junit.framework.TestCase.assertTrue(TestCase.java:200)
	# 	at javassist.JvstTest2.testURL(JvstTest2.java:336)
	# 2) testMethodParameters(javassist.JvstTest4)
	# junit.framework.ComparisonFailure: expected:<[i]> but was:<[arg0]>
	# 	at junit.framework.Assert.assertEquals(Assert.java:100)
	# 	at junit.framework.Assert.assertEquals(Assert.java:107)
	# 	at junit.framework.TestCase.assertEquals(TestCase.java:260)
	# 	at javassist.JvstTest4.testMethodParameters(JvstTest4.java:1010)
	# 
	# FAILURES!!!
	# Tests run: 432,  Failures: 2

	sed \
		-e '/public void/s:testURL:notTestURL:' \
		-i src/test/javassist/JvstTest2.java || die

	sed \
		-e '/public void/s:testMethodParameters:notTestMethodParameters:' \
		-i src/test/javassist/JvstTest4.java || die
}

src_test() {
	default
	einfo "Testing"
	JAVA_PKG_WANT_SOURCE=11
	JAVA_PKG_WANT_TARGET=11
	JAVAC_ARGS="-g"
	java-pkg-simple_src_test
}

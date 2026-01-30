# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

TEST="67a7aa5ac345fa46bfcb5fc1154ed14807e3f87d"

DESCRIPTION="XMLUnit extends JUnit and NUnit to enable unit testing of XML"
HOMEPAGE="https://sourceforge.net/projects/xmlunit/ https://www.xmlunit.org"
SRC_URI="https://github.com/xmlunit/xmlunit/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/xmlunit/test-resources/archive/${TEST}.tar.gz -> xmlunit-test-resources-${PV}.tar.gz )"
S="${WORKDIR}/xmlunit-${PV}/xmlunit-core"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	>=dev-java/jaxb-api-2.3.3-r2:2
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/asm-9.9:0
		>=dev-java/byte-buddy-1.17.8:0
		>=dev-java/hamcrest-3.0:0
		>=dev-java/jaxb-runtime-2.3.8:2
		>=dev-java/mockito-5.20.0:0
	)
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="jaxb-api-2"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXCLUDES=( org.xmlunit.TestResources ) # org.junit.runners.model.InvalidTestClassError: Invalid test class
JAVA_TEST_GENTOO_CLASSPATH="asm byte-buddy hamcrest jaxb-runtime-2 junit-4 mockito"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	mv "${WORKDIR}/test-resources-${TEST}"/* ../test-resources || die
	java-pkg-simple_src_test
}

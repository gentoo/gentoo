# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

TEST="67a7aa5ac345fa46bfcb5fc1154ed14807e3f87d"

DESCRIPTION="XMLUnit extends JUnit and NUnit to enable unit testing of XML"
HOMEPAGE="https://sourceforge.net/projects/xmlunit/ https://www.xmlunit.org"
SRC_URI="https://github.com/xmlunit/xmlunit/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/xmlunit/test-resources/archive/${TEST}.tar.gz -> xmlunit-test-resources-${PV}.tar.gz )"
S="${WORKDIR}/xmlunit-${PV}/xmlunit-legacy"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	dev-java/junit:4
	>=dev-java/xmlunit-core-${PV}:0
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/mockito-5.20.0:0
	)
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.custommonkey.xmlunit"
JAVA_CLASSPATH_EXTRA="junit-4 xmlunit-core"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4 mockito"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	mv "${WORKDIR}/test-resources-${TEST}"/* ../test-resources || die
	java-pkg-simple_src_test
}

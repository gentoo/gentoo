# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XMLUnit with AssertJ fluent API"
HOMEPAGE="https://www.xmlunit.org/"
SRC_URI="https://github.com/xmlunit/xmlunit/releases/download/v${PV}/xmlunit-${PV}-src.tar.gz"
S="${WORKDIR}/xmlunit-${PV}-src/xmlunit-assertj3"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	>=virtual/jdk-1.8:*
	>=dev-java/assertj-core-3.27.7:0
	>=dev-java/byte-buddy-1.18.4:0
	~dev-java/xmlunit-core-${PV}:0
	test? (
		>=dev-java/asm-9.9.1:0
		>=dev-java/hamcrest-3.0:0
		>=dev-java/mockito-5.21.0:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,HELP_WANTED,README,RELEASE_NOTES}.md )
PATCHES=(
	"${FILESDIR}"/xmlunit-assertj-2.13.0-ValueAssertTest.patch
	"${FILESDIR}"/xmlunit-assertj-2.13.0-XmlAsserValidationTest.patch # Some of them need network access
)

JAVA_AUTOMATIC_MODULE_NAME="org.xmlunit.assertj"
JAVA_CLASSPATH_EXTRA="assertj-core byte-buddy xmlunit-core"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXCLUDES="org.xmlunit.TestResources" # Invalid test class
JAVA_TEST_GENTOO_CLASSPATH="asm junit-4 mockito xmlunit-core"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	cp {../xmlunit-core/,}src/test/java/org/xmlunit/TestResources.java || die
}

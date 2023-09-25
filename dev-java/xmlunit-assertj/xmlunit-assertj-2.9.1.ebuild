# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.xmlunit:xmlunit-assertj:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XMLUnit with AssertJ fluent API"
HOMEPAGE="https://www.xmlunit.org/"
SRC_URI="https://github.com/xmlunit/xmlunit/releases/download/v${PV}/xmlunit-${PV}-src.tar.gz"
S="${WORKDIR}/xmlunit-${PV}-src/xmlunit-assertj"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

PROPERTIES="test_network"
RESTRICT="test"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	dev-java/assertj-core:3
	dev-java/byte-buddy:0
	~dev-java/xmlunit-core-${PV}:2
	test? (
		dev-java/hamcrest:0
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

DOCS=( ../{CONTRIBUTING,HELP_WANTED,README,RELEASE_NOTES}.md )

JAVA_AUTOMATIC_MODULE_NAME="org.xmlunit.assertj"
JAVA_CLASSPATH_EXTRA="
	assertj-core-3
	byte-buddy
	xmlunit-core-2
"
JAVA_SRC_DIR="src/main/java"

# org.junit.runners.model.InvalidTestClassError: Invalid test class '
JAVA_TEST_EXCLUDES="org.xmlunit.TestResources"
JAVA_TEST_GENTOO_CLASSPATH="
	junit-4
	mockito-4
	xmlunit-core-2
"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	cp {../xmlunit-core/,}src/test/java/org/xmlunit/TestResources.java || die
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-text:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Apache Commons Text is a library focused on algorithms working on strings"
HOMEPAGE="https://commons.apache.org/proper/commons-text/"
SRC_URI="mirror://apache//commons/text/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/text/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ggregory )"
CP_DEPEND=">=dev-java/commons-lang-3.18.0:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	test? (
		>=dev-java/commons-io-2.20.0:0
		>=dev-java/commons-lang-3.18.0:0
		dev-java/commons-rng:0
		>=dev-java/jmh-core-1.37:0
		>=dev-java/jmh-generator-annprocess-1.37:0
		dev-java/mockito:4
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( CONTRIBUTING.md NOTICE.txt README.md RELEASE-NOTES.txt )
PATCHES=(
	"${FILESDIR}/commons-text-1.14.0-ResourceBundleStringLookupTest.patch"
	"${FILESDIR}/commons-text-1.14.0-ScriptStringLookupTest.patch"
	"${FILESDIR}/commons-text-1.14.0-StringSubstitutorWithInterpolatorStringLookupTest.patch"
	"${FILESDIR}/commons-text-1.14.0-UrlDecoderStringLookupTest.patch"
	"${FILESDIR}/commons-text-1.14.0-UrlEncoderStringLookupTest.patch"
	"${FILESDIR}/commons-text-1.14.0-UrlStringLookupTest.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.text"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="commons-io commons-lang commons-rng jmh-core jmh-generator-annprocess mockito-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ggregory.asc"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

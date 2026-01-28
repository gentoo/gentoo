# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Apache Commons Text is a library focused on algorithms working on strings"
HOMEPAGE="https://commons.apache.org/proper/commons-text/"
SRC_URI="mirror://apache//commons/text/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/text/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-apache-commons-20251102 )"
CP_DEPEND=">=dev-java/commons-lang-3.20.0:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	test? (
		>=dev-java/asm-9.9:0
		>=dev-java/byte-buddy-1.17.8:0
		>=dev-java/commons-io-2.21.0:0
		dev-java/commons-rng:0
		>=dev-java/jmh-core-1.37:0
		>=dev-java/jmh-generator-annprocess-1.37:0
		>=dev-java/jna-5.18.1:0
		>=dev-java/jsr305-3.0.2-r1:0
		>=dev-java/junit-pioneer-1.9.1-r1:0
		dev-java/junit:5[-vintage]
		>=dev-java/mockito-5.20.0-r1:0
		>=dev-java/objenesis-3.4:0
		>=dev-java/opentest4j-1.3.0-r1:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( CONTRIBUTING.md NOTICE.txt README.md RELEASE-NOTES.txt )
PATCHES=(
	"${FILESDIR}/commons-text-1.14.0-ScriptStringLookupTest.patch"
	"${FILESDIR}/commons-text-1.14.0-StringSubstitutorWithInterpolatorStringLookupTest.patch"
	"${FILESDIR}/commons-text-1.14.0-UrlStringLookupTest.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.text"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm byte-buddy commons-io commons-rng jmh-core
	jmh-generator-annprocess jna jsr305 junit-pioneer junit-5 mockito objenesis opentest4j"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	export LC_ALL="en_US.UTF-8"	# needed for DateStringLookupTest
}

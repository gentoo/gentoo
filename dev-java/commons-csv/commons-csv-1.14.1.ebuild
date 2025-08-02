# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"
MAVEN_ID="org.apache.commons:commons-csv:1.14.1"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Simple interface for reading and writing CSV files of various types"
HOMEPAGE="https://commons.apache.org/proper/commons-csv/"
H2V="2.2.224"
SRC_URI="mirror://apache/commons/csv/source/${P}-src.tar.gz
	test? ( https://repo1.maven.org/maven2/com/h2database/h2/${H2V}/h2-${H2V}.jar )
	verify-sig? ( https://downloads.apache.org/commons/csv/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ggregory )"

# Min java 11 because of module-info.
# Restrict to max java 25, because of error with java 26:
# * ERROR: dev-java/commons-csv-1.14.1::testing failed (test phase):
# *   ConsoleLauncher failed
DEPEND="
	|| ( virtual/jdk:25 virtual/jdk:21 virtual/jdk:17 virtual/jdk:11 )
	>=dev-java/commons-codec-1.19.0:0
	>=dev-java/commons-io-2.20.0:0
	dev-java/findbugs-annotations:0
	test? (
		>=dev-java/commons-lang-3.18.0:0
		dev-java/junit:5[-vintage]
		dev-java/mockito:4
		dev-java/opentest4j:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( LICENSE.txt NOTICE.txt RELEASE-NOTES.txt )

JAVA_CLASSPATH_EXTRA="commons-codec commons-io findbugs-annotations"
JAVA_GENTOO_CLASSPATH_EXTRA=:"${DISTDIR}/h2-${H2V}.jar"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="commons-io commons-lang junit-5 mockito-4 opentest4j"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ggregory.asc"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.gz{,.asc}
	default
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-csv:1.12.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Simple interface for reading and writing CSV files of various types"
HOMEPAGE="https://commons.apache.org/proper/commons-csv/"
SRC_URI="mirror://apache/commons/csv/source/${P}-src.tar.gz
	verify-sig? ( https://archive.apache.org/dist/commons/csv/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

RESTRICT="test"	#839681

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

DEPEND="
	>=virtual/jdk-11:*
	>=dev-java/commons-codec-1.18.0:0
	>=dev-java/commons-io-2.18.0:1
	test? (
		>=dev-java/commons-lang-3.17.0:3.6
		dev-java/junit:5
		dev-java/mockito:4
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( LICENSE.txt NOTICE.txt RELEASE-NOTES.txt )

JAVA_CLASSPATH_EXTRA="
	commons-codec
	commons-io-1
"

JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	commons-io-1
	commons-lang-3.6
	junit-5
	mockito-4
"

JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

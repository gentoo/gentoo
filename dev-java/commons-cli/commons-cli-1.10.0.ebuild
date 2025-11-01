# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-cli:commons-cli:1.10.0"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

# Avoid circular dependency
JAVA_DISABLE_DEPEND_ON_JAVA_DEP_CHECK="true"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="A Java library for working with the command line arguments and options"
HOMEPAGE="https://commons.apache.org/proper/commons-cli/"
SRC_URI="mirror://apache/commons/cli/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/cli/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ggregory )"

# [-vintage] because, if junit:5 compiled with 'USE=vintage':
# Error: Module junit not found, required by org.junit.vintage.engine
DEPEND="
	>=virtual/jdk-11:*
	test? (
		>=dev-java/commons-io-2.20.0:0
		>=dev-java/commons-lang-3.18.0:0
		>=dev-java/commons-text-1.14.0:0
		dev-java/junit:5[-vintage]
		dev-java/mockito:4
		dev-java/opentest4j:0
	)
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="commons-io commons-lang commons-text junit-5 mockito-4 opentest4j"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ggregory.asc"

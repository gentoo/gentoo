# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Implementations of common encoders and decoders in Java"
HOMEPAGE="https://commons.apache.org/proper/commons-codec/"
SRC_URI="mirror://apache/commons/codec/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/codec/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

# [-vintage] because, if junit:5 compiled with 'USE=vintage':
# Error: Module junit not found, required by org.junit.vintage.engine
DEPEND="
	>=virtual/jdk-11:*
	test? (
		>=dev-java/commons-io-2.21.0:0
		>=dev-java/commons-lang-3.20.0:0
		>=dev-java/hamcrest-3.0:0
		dev-java/junit:5[-vintage]
		>=dev-java/opentest4j-1.3.0-r1:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="commons-io commons-lang hamcrest junit-5 opentest4j"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Apache Commons Random Numbers Generators"
HOMEPAGE="https://commons.apache.org/proper/commons-rng/"
SRC_URI="mirror://apache/commons/rng/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/rng/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-aherbert )"

# [-vintage] because, if junit:5 compiled with 'USE=vintage':
# Error: Module junit not found, required by org.junit.vintage.engine
DEPEND="
	>=virtual/jdk-11:*
	test? (
		>=dev-java/commons-math-3.6.1-r2:3
		>=dev-java/jmh-core-1.37:0
		dev-java/junit:5[-vintage]
		dev-java/opentest4j:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/commons-rng-1.6-skipFailingTests.patch" )

JAVADOC_SRC_DIRS=(
	commons-rng-client-api/src/main/java
	commons-rng-core/src/main/java
	commons-rng-simple/src/main/java
)
JAVA_TEST_GENTOO_CLASSPATH="commons-math-3 jmh-core junit-5 opentest4j"
JAVA_TEST_SRC_DIR=( commons-rng-{client-api,core,simple}/src/test/java )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/aherbert.asc"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_compile() {
	einfo "Compiling commons-rng-client-api"
	JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.rng.api"
	JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}.api"
	JAVA_JAR_FILENAME="commons-rng-client-api.jar"
	JAVA_MODULE_INFO_OUT="commons-rng-client-api/src/main"
	JAVA_RESOURCE_DIRS=()
	JAVA_SRC_DIR="commons-rng-client-api/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":commons-rng-client-api.jar"
	rm -r target || die

	einfo "Compiling commons-rng-core"
	JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.rng.core"
	JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}.core"
	JAVA_JAR_FILENAME="commons-rng-core.jar"
	JAVA_MODULE_INFO_OUT="commons-rng-core/src/main"
	JAVA_RESOURCE_DIRS=()
	JAVA_SRC_DIR="commons-rng-core/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":commons-rng-core.jar"
	rm -r target || die

	einfo "Compiling commons-rng-core"
	JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.rng.simple"
	JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}.simple"
	JAVA_JAR_FILENAME="commons-rng-simple.jar"
	JAVA_MODULE_INFO_OUT="commons-rng-simple/src/main"
	JAVA_RESOURCE_DIRS=()
	JAVA_SRC_DIR="commons-rng-simple/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":commons-rng-simple.jar"
	rm -r target || die

	use doc && ejavadoc
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar commons-rng-{client-api,core}.jar
}

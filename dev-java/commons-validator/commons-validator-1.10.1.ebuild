# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Commons component to validate user input, or data input"
HOMEPAGE="https://commons.apache.org/proper/commons-validator/"
SRC_URI="mirror://apache/commons/validator/source/${P}-src.tar.gz
	verify-sig? ( mirror://apache/commons/validator/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="log4j"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

COMMON_DEPEND="
	>=dev-java/commons-beanutils-1.11.0:0[log4j=]
	>=dev-java/commons-collections-3.2.2-r2:0
	>=dev-java/commons-digester-2.1-r3:2.1[log4j=]
	>=dev-java/commons-logging-1.3.5-r1:0[log4j=]
	log4j? (
		>=dev-java/jakarta-activation-api-1.2.2-r1:1
		>=dev-java/jnacl-1.0-r1:0
		>=dev-java/log4j-12-api-2.25.2:0
		>=dev-java/snakeyaml-2.5:0
	)
"

# [-vintage] because, if junit:5 compiled with 'USE=vintage':
# Error: Module junit not found, required by org.junit.vintage.engine
DEPEND="
	${COMMON_DEPEND}
	dev-java/jakarta-servlet-api:4
	dev-java/slf4j-api:0
	>=virtual/jdk-11:*
	test? (
		>=dev-java/commons-csv-1.14.1-r1:0
		>=dev-java/commons-codec-1.20.0:0
		>=dev-java/commons-io-2.21.0:0
		>=dev-java/commons-lang-3.20.0:0
		>=dev-java/junit-clptr-1.2.2-r1:0
		>=dev-java/junit-pioneer-1.9.1-r1:0
		dev-java/junit:5[-vintage]
		>=dev-java/opentest4j-1.3.0-r1:0
	)
"

RDEPEND="
	${COMMON_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="jakarta-servlet-api-4 slf4j-api"
JAVA_GENTOO_CLASSPATH="commons-beanutils commons-collections commons-digester-2.1 commons-logging"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	commons-csv
	commons-codec
	commons-io
	commons-lang
	junit-clptr
	junit-pioneer
	junit-5
	opentest4j
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

src_prepare() {
	java-pkg-2_src_prepare

	if use log4j; then
		JAVA_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only --with-dependencies \
			log4j-12-api,snakeyaml,jnacl,jakarta-activation-api-1)"
	fi

	# src/test/java/org/apache/commons/validator/routines/IBANValidatorTest.java:52: error: cannot find symbol
	# import org.junit.jupiter.params.provider.FieldSource;
	rm src/test/java/org/apache/commons/validator/routines/IBANValidatorTest.java || die
}

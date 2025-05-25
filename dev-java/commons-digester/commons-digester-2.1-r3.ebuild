# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-digester:commons-digester:2.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Reads XML configuration files to provide initialization of various Java objects"
HOMEPAGE="https://commons.apache.org/digester/"
SRC_URI="mirror://apache/commons/digester/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/digester/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/commons-digester-${PV}-src"

LICENSE="Apache-2.0"
SLOT="2.1"
KEYWORDS="amd64 ppc64"
IUSE="log4j"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

COMMON_DEPEND="
	>=dev-java/commons-beanutils-1.10.1:0[log4j=]
	dev-java/commons-collections:0
	>=dev-java/commons-logging-1.3.5:0[log4j=]
	dev-java/jakarta-servlet-api:4
	dev-java/slf4j-api:0
	log4j? (
		dev-java/log4j-12-api:2
		dev-java/log4j-api:2
	)
"

DEPEND="
	${COMMON_DEPEND}
	>=virtual/jdk-11:*
"

RDEPEND="
	${COMMON_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {LICENSE,NOTICE,RELEASE-NOTES}.txt )

#	JAVA_ENCODING="iso-8859-1"
JAVA_GENTOO_CLASSPATH="
	commons-beanutils
	commons-collections
	commons-logging
	jakarta-servlet-api-4
	slf4j-api
"

JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	java-pkg-2_src_prepare

	if use log4j; then
		JAVA_GENTOO_CLASSPATH+="
			log4j-12-api-2
			log4j-api-2
		"
	fi
}

src_test() {
	pushd src/test/java || die
		# Exclusions according to 212,215 pom.xml
		local JAVA_TEST_RUN_ONLY=$(find * \
			! -name "Abstract*.java" ! -name "TestBean.java" \
			! -name "TestRule.java" ! -name "TestRuleSet.java" \
			-name "*TestCase.java" -o -name "*Test.java")
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd
	java-pkg-simple_src_test
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-validator:commons-validator:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Commons component to validate user input, or data input"
HOMEPAGE="https://commons.apache.org/proper/commons-validator/"
SRC_URI="mirror://apache/commons/validator/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/validator/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64"
IUSE="log4j"
RESTRICT="test" #839681

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

COMMON_DEPEND="
	>=dev-java/commons-beanutils-1.10.1:0[log4j=]
	dev-java/commons-collections:0
	>=dev-java/commons-digester-2.1-r3:2.1[log4j=]
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

JAVA_GENTOO_CLASSPATH="
	commons-beanutils
	commons-collections
	commons-digester-2.1
	commons-logging
	jakarta-servlet-api-4
	slf4j-api
"

JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare

	if use log4j; then
		JAVA_GENTOO_CLASSPATH+="
			log4j-12-api-2
			log4j-api-2
		"
	fi
}

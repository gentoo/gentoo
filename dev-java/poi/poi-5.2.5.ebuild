# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.poi:poi-main:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Maven build of Apache POI for Sonar checks"
HOMEPAGE="https://poi.apache.org/"
RELEASE_DATE="20231118"
SRC_URI="https://archive.apache.org/dist/poi/release/src/poi-src-${PV}-${RELEASE_DATE}.tgz
	verify-sig? ( https://archive.apache.org/dist/poi/release/src/poi-src-${PV}-${RELEASE_DATE}.tgz.asc )"
S="${WORKDIR}/poi-src-${PV}-${RELEASE_DATE}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/poi.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-poi )"
DEPEND="
	dev-java/commons-codec:0
	dev-java/commons-collections:4
	dev-java/commons-io:1
	dev-java/commons-math:3
	dev-java/log4j-api:2
	>=dev-java/sparsebitset-1.3:0
	>=virtual/jdk-11:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.poi.poi"
JAVA_CLASSPATH_EXTRA="
	commons-codec
	commons-collections-4
	commons-io-1
	commons-math-3
	log4j-api-2
	sparsebitset
"
JAVA_RESOURCE_DIRS="poi/src/main/resources"
JAVA_SRC_DIR=( poi/src/main/java{,9} )

src_prepare() {
	java-pkg-2_src_prepare
	sed \
		-e "s:@VERSION@:${PV}:g" \
		-e "s:@DSTAMP@:${RELEASE_DATE}:g" \
		poi/src/main/version/Version.java.template \
		> poi/src/main/java/org/apache/poi/Version.java || die
	# log4j-api does not provide Automatic-Module
	sed \
		-e '/org.apache.logging.log4j/d' \
		-i poi/src/main/java9/module-info.java || die
}

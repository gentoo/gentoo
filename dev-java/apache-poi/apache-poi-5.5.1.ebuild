# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Java API to access Mocrosoft format files"
HOMEPAGE="https://poi.apache.org/"
RELEASE_DATE="20251126"
SRC_URI="https://downloads.apache.org/poi/release/src/${PN}-src-${PV}-${RELEASE_DATE}.tgz
	verify-sig? ( https://downloads.apache.org/poi/release/src/${PN}-src-${PV}-${RELEASE_DATE}.tgz.asc )"
S="${WORKDIR}/${PN}-src-${PV}-${RELEASE_DATE}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-apache-poi-20240421 )"
DEPEND="
	>=dev-java/commons-codec-1.20.0:0
	>=dev-java/commons-collections-4.5.0:4
	>=dev-java/commons-io-2.21.0:0
	dev-java/commons-math:3
	>=dev-java/log4j-api-2.25.2:0
	dev-java/osgi-core:0
	>=dev-java/sparsebitset-1.3:0
	>=virtual/jdk-11:*
"

RDEPEND="
	!<dev-java/jackcess-4.0.10:0
	>=virtual/jre-1.8:*
"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.poi.poi"
JAVA_CLASSPATH_EXTRA="commons-codec commons-collections-4 commons-io commons-math-3 log4j-api osgi-core sparsebitset"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.poi.poi"
JAVA_RELEASE_SRC_DIRS=( ["9"]="poi/src/main/java9" )
JAVA_RESOURCE_DIRS="poi/src/main/resources"
JAVA_SRC_DIR="poi/src/main/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/apache-poi.asc"

src_prepare() {
	java-pkg-2_src_prepare
	sed \
		-e "s:@VERSION@:${PV}:g" \
		-e "s:@DSTAMP@:${RELEASE_DATE}:g" \
		poi/src/main/version/Version.java.template \
		> poi/src/main/java/org/apache/poi/Version.java || die
}

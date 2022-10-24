# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# tests depend on junit-jupiter which is not packaged
# https://github.com/apache/poi/blob/REL_5_2_2/poi/build.gradle#L51-L56
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.poi:poi-main:5.2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Maven build of Apache POI for Sonar checks"
HOMEPAGE="https://poi.apache.org/"
RELEASE_DATE="20220909"
SRC_URI="mirror://apache/poi/release/src/poi-src-${PV}-${RELEASE_DATE}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	>=dev-java/commons-codec-1.15-r1:0
	>=dev-java/commons-collections-4.4-r1:4
	>=dev-java/commons-io-2.11.0-r1:1
	>=dev-java/commons-math-3.6.1-r2:3
	dev-java/log4j-api:2
	dev-java/sparsebitset:0
	>=virtual/jdk-11:*
"

RDEPEND="
	>=virtual/jre-1.8:*"

S="${WORKDIR}/poi-src-${PV}-${RELEASE_DATE}-${PV}"

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
	default
	sed \
		-e "s:@VERSION@:${PV}:g" \
		-e "s:@DSTAMP@:${RELEASE_DATE}:g" \
		poi/src/main/version/Version.java.template \
		> poi/src/main/java/org/apache/poi/Version.java || die
	# Neither log4j-api nor SparseBitSet provide Automatic-Module
	sed \
		-e '/SparseBitSet/d' \
		-e '/org.apache.logging.log4j/d' \
		-i poi/src/main/java9/module-info.java || die
}

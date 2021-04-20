# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom poi-5.0.0/sonar/main/pom.xml --download-uri https://archive.apache.org/dist/poi/release/src/poi-src-5.0.0-20210120.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild poi-5.0.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.poi:poi-main:5.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Maven build of Apache POI for Sonar checks"
HOMEPAGE="https://poi.apache.org/"
SRC_URI="https://archive.apache.org/dist/${PN}/release/src/${PN}-src-${PV}-20210120.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

# Common dependencies
# POM: ${P}/sonar/main/pom.xml
# com.zaxxer:SparseBitSet:1.2 -> >=dev-java/sparsebitset-1.2:0
# commons-codec:commons-codec:1.15 -> >=dev-java/commons-codec-1.11:0
# org.apache.commons:commons-collections4:4.4 -> >=dev-java/commons-collections-4.1:4
# org.apache.commons:commons-math3:3.6.1 -> >=dev-java/commons-math-3.6.1:3
# org.slf4j:jcl-over-slf4j:1.7.30 -> !!!artifactId-not-found!!!
# org.slf4j:slf4j-api:1.7.30 -> >=dev-java/slf4j-api-1.7.30:0

#	CDEPEND="
#		!!!artifactId-not-found!!!
#		>=dev-java/commons-codec-1.11:0
#		>=dev-java/commons-collections-4.1:4
#		>=dev-java/commons-math-3.6.1:3
#		>=dev-java/slf4j-api-1.7.30:0
#		>=dev-java/sparsebitset-1.2:0
#	"
CDEPEND="
	>=dev-java/commons-codec-1.11:0
	>=dev-java/commons-collections-4.1:4
	>=dev-java/commons-math-3.6.1:3
	>=dev-java/slf4j-api-1.7.30:0
	>=dev-java/sparsebitset-1.2:0
	dev-java/commons-logging:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="sparsebitset,commons-codec,commons-collections-4,commons-logging,commons-math-3,slf4j-api"
JAVA_SRC_DIR="src/java"

src_prepare() {
	default
	java-pkg_clean
}

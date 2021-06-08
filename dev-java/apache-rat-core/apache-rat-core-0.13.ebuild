# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom apache-rat-core/pom.xml --download-uri https://mirrors.nav.ro/apache//creadur/apache-rat-0.13/apache-rat-0.13-src.tar.bz2 --slot 0 --keywords "~amd64 ~x86" --ebuild apache-rat-core-0.13.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.rat:apache-rat-core:0.13"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The core functionality, shared by the Ant tasks and the Maven plugin."
HOMEPAGE="https://creadur.apache.org/rat/apache-rat-core/"
SRC_URI="mirror://apache//creadur/apache-rat-${PV}/apache-rat-${PV}-src.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

# Common dependencies
# POM: ${PN}/pom.xml
# commons-cli:commons-cli:1.3.1 -> >=dev-java/commons-cli-1.3.1:1
# commons-collections:commons-collections:3.2.2 -> !!!suitble-mavenVersion-not-found!!!
# commons-io:commons-io:2.2 -> >=dev-java/commons-io-2.8.0:1
# commons-lang:commons-lang:2.6 -> >=dev-java/commons-lang-2.6:2.1
# org.apache.commons:commons-compress:1.11 -> >=dev-java/commons-compress-1.20:0
# org.apache.rat:apache-rat-api:0.13 -> >=dev-java/apache-rat-api-0.13:0

CDEPEND="
	>=dev-java/commons-cli-1.3.1:1
	>=dev-java/commons-compress-1.20:0
	dev-java/commons-collections:0
	>=dev-java/commons-io-2.8.0:1
	dev-java/commons-lang:3.6
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/apache-rat-${PV}/${PN}"

PATCHES=(
	"${FILESDIR}/${P}-commons-lang3.patch"
)

JAVA_GENTOO_CLASSPATH="commons-cli-1,commons-collections,commons-io-1,commons-lang-3.6,commons-compress"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)

src_prepare() {
	default
	java-utils-2_src_prepare
}

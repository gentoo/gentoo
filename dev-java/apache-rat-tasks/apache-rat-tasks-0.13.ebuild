# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom apache-rat-tasks/pom.xml --download-uri https://mirrors.nav.ro/apache//creadur/apache-rat-0.13/apache-rat-0.13-src.tar.bz2 --slot 0 --keywords "~amd64 ~x86" --ebuild apache-rat-tasks-0.13.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.rat:apache-rat-tasks:0.13"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A plugin for Apache Ant that runs Apache Rat to audit the source"
HOMEPAGE="https://creadur.apache.org/rat/apache-rat-tasks/"
SRC_URI="mirror://apache//creadur/apache-rat-${PV}/apache-rat-${PV}-src.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Common dependencies
# POM: ${PN}/pom.xml
# org.apache.rat:apache-rat-core:0.13 -> >=dev-java/apache-rat-core-0.13:0

CDEPEND="
	dev-java/ant-core:0
	~dev-java/apache-rat-core-${PV}:0
"

# Compile dependencies
# POM: ${PN}/pom.xml
# org.apache.ant:ant:1.9.12 -> !!!groupId-not-found!!!
# POM: ${PN}/pom.xml
# test? junit:junit:4.12 -> >=dev-java/junit-4.12:4
# test? org.apache.ant:ant-antunit:1.4 -> !!!groupId-not-found!!!
# test? org.apache.ant:ant-testutil:1.9.12 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		dev-java/ant-testutil:0
	)"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/apache-rat-${PV}/${PN}"

PATCHES=(
	"${FILESDIR}/${P}-fix-tests.patch"
)

JAVA_GENTOO_CLASSPATH="ant-core,apache-rat-core"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="ant-testutil,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)

src_prepare() {
	default
	java-utils-2_src_prepare
}

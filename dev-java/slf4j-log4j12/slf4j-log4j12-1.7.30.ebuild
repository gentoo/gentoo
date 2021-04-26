# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom slf4j-v_1.7.30/slf4j-log4j12/pom.xml --download-uri https://github.com/qos-ch/slf4j/archive/refs/tags/v_1.7.30.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild slf4j-log4j12-1.7.30.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.slf4j:slf4j-log4j12:1.7.30"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SLF4J LOG4J-12 Binding"
HOMEPAGE="https://www.slf4j.org"
SRC_URI="https://github.com/qos-ch/slf4j/archive/refs/tags/v_${PV}.tar.gz -> slf4j-${PV}-sources.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

# slf4j-v_1.7.30/slf4j-log4j12/src/test/java/org/slf4j/impl/Log4j12MultithreadedInitializationTest.java:35: error: cannot find symbol
# import org.slf4j.helpers.MultithreadedInitializationTest;
#                         ^
#   symbol:   class MultithreadedInitializationTest
RESTRICT="test"

# Common dependencies
# POM: slf4j-v_${PV}/${PN}/pom.xml
# log4j:log4j:1.2.17 -> >=dev-java/log4j-1.2.17:0
# org.slf4j:slf4j-api:1.7.30 -> >=dev-java/slf4j-api-1.7.30:0

CDEPEND="
	>=dev-java/log4j-1.2.17:0
	>=dev-java/slf4j-api-1.7.30:0
"

# Compile dependencies
# POM: slf4j-v_${PV}/${PN}/pom.xml
# test? junit:junit:4.12 -> >=dev-java/junit-4.12:4
# test? org.slf4j:slf4j-api:1.7.30 -> >=dev-java/slf4j-api-1.7.30:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		>=dev-java/slf4j-api-1.7.30:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="log4j,slf4j-api"
JAVA_SRC_DIR="slf4j-v_${PV}/${PN}/src/main/java"
JAVA_RESOURCE_DIRS=(
	"slf4j-v_${PV}/${PN}/src/main/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4,slf4j-api"
JAVA_TEST_SRC_DIR="slf4j-v_${PV}/${PN}/src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"slf4j-v_${PV}/${PN}/src/test/resources"
)

src_prepare() {
	default
	java-pkg_clean
}

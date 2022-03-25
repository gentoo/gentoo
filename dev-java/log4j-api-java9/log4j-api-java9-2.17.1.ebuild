# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom log4j-api-java9/pom.xml --download-uri mirror://apache/logging/log4j/2.17.1/apache-log4j-2.17.1-src.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64" --ebuild log4j-api-java9-2.17.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.logging.log4j:log4j-api-java9:2.17.1"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The Apache Log4j API (Java 9)"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

# junit-jupiter is not available in ::gentoo
RESTRICT="test"

# Compile dependencies
# POM: ${PN}/pom.xml
# test? org.apache.maven:maven-core:3.6.3 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-engine:5.7.2 -> !!!groupId-not-found!!!

DEPEND=">=virtual/jdk-11:*"
#	test? (
#		!!!groupId-not-found!!!
#	)
#"

RDEPEND=">=virtual/jre-11:*"

DOCS=( {CONTRIBUTING,README,RELEASE-NOTES,SECURITY}.md LICENSE.txt )

S="${WORKDIR}/apache-log4j-${PV}-src"

JAVA_SRC_DIR="${PN}/src/main/java"
JAVA_RESOURCE_DIRS="${PN}/src/assembly"

#	JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!,!!!groupId-not-found!!!"
#	JAVA_TEST_SRC_DIR="${PN}/src/test/java"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}

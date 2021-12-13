# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom log4j-core-java9/pom.xml --download-uri mirror://apache/logging/log4j/2.15.0/apache-log4j-2.15.0-src.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild log4j-core-java9-2.15.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.logging.log4j:log4j-core-java9:2.15.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The Apache Log4j Implementation (Java 9)"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Common dependencies
# POM: ${PN}/pom.xml
# org.apache.logging.log4j:log4j-api:2.15.0 -> >=dev-java/log4j-api-2.15.0:2

CP_DEPEND="dev-java/log4j-api:2 "

# Compile dependencies
# POM: ${PN}/pom.xml
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# test? org.apache.maven:maven-core:3.6.3 -> !!!groupId-not-found!!!

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README,RELEASE-NOTES,SECURITY}.md LICENSE.txt )

S="${WORKDIR}/apache-log4j-${PV}-src"

JAVA_SRC_DIR="${PN}/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="${PN}/src/test/java"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}

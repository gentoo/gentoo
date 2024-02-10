# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom log4j-1.2-api/pom.xml --download-uri mirror://apache/logging/log4j/2.19.0/apache-log4j-2.19.0-src.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild log4j-12-api-2.19.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.logging.log4j:log4j-1.2-api:2.19.0"
JAVA_TESTING_FRAMEWORKS="junit-vintage junit-jupiter"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The Apache Log4j 1.x Compatibility API"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# We don't have junit-vintage and junit-jupiter
RESTRICT="test"

# Common dependencies
# POM: log4j-1.2-api/pom.xml
# org.apache.logging.log4j:log4j-api:2.19.0 -> >=dev-java/log4j-api-2.19.0:2
# org.apache.logging.log4j:log4j-core:2.19.0 -> >=dev-java/log4j-core-2.19.0:2

CP_DEPEND="
	~dev-java/log4j-api-${PV}:2
	~dev-java/log4j-core-${PV}:2
"

# Compile dependencies
# POM: log4j-1.2-api/pom.xml
# javax.jms:javax.jms-api:2.0.1 -> !!!groupId-not-found!!!
# POM: log4j-1.2-api/pom.xml
# test? com.fasterxml.jackson.dataformat:jackson-dataformat-xml:2.13.4 -> >=dev-java/jackson-dataformat-xml-2.13.4:0
# test? commons-io:commons-io:2.11.0 -> >=dev-java/commons-io-2.11.0:1
# test? org.apache.commons:commons-lang3:3.12.0 -> >=dev-java/commons-lang-3.12.0:3.6
# test? org.apache.felix:org.apache.felix.framework:7.0.5 -> >=dev-java/felix-framework-7.0.5:0
# test? org.apache.logging.log4j:log4j-api:2.19.0 -> >=dev-java/log4j-api-2.19.0:2
# test? org.apache.logging.log4j:log4j-core:2.19.0 -> >=dev-java/log4j-core-2.19.0:2
# test? org.apache.velocity:velocity:1.7 -> !!!artifactId-not-found!!!
# test? org.eclipse.tycho:org.eclipse.osgi:3.13.0.v20180226-1711 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-engine:5.9.0 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-params:5.9.0 -> !!!groupId-not-found!!!
# test? org.junit.vintage:junit-vintage-engine:5.9.0 -> !!!groupId-not-found!!!
# test? org.mockito:mockito-core:4.4.0 -> >=dev-java/mockito-4.6.1:4
# test? oro:oro:2.0.8 -> >=dev-java/jakarta-oro-2.0.8:2.0

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	dev-java/javax-jms-api:0"
#	test? (
#		!!!artifactId-not-found!!!
#		!!!groupId-not-found!!!
#		>=dev-java/commons-io-2.11.0:1
#		>=dev-java/commons-lang-3.12.0:3.6
#		>=dev-java/felix-framework-7.0.5:0
#		>=dev-java/jackson-dataformat-xml-2.13.4:0
#		>=dev-java/jakarta-oro-2.0.8:2.0
#		>=dev-java/log4j-api-2.19.0:2
#		>=dev-java/log4j-core-2.19.0:2
#		>=dev-java/mockito-4.6.1:4
#	)
#"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {CONTRIBUTING,README,RELEASE-NOTES,SECURITY}.md )

S="${WORKDIR}/apache-log4j-${PV}-src"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.log4j"
JAVA_CLASSPATH_EXTRA="javax-jms-api"
JAVA_RESOURCE_DIRS="log4j-1.2-api/src/main/resources"
JAVA_SRC_DIR="log4j-1.2-api/src/main/java"

#JAVA_TEST_GENTOO_CLASSPATH="jackson-dataformat-xml,commons-io-1,commons-lang-3.6,!!!groupId-not-found!!!,log4j-api-2,log4j-core-2,!!!artifactId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,mockito-4,jakarta-oro-2.0"
#JAVA_TEST_SRC_DIR="log4j-1.2-api/src/test/java"
#JAVA_TEST_RESOURCE_DIRS=(
#	"log4j-1.2-api/src/test/resources"
#)

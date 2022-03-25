# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom log4j-1.2-api/pom.xml --download-uri mirror://apache/logging/log4j/2.17.1/apache-log4j-2.17.1-src.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild log4j-12-api-2.17.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.logging.log4j:log4j-1.2-api:2.17.1"
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
# org.apache.logging.log4j:log4j-api:2.17.1 -> >=dev-java/log4j-api-2.17.1:2
# org.apache.logging.log4j:log4j-core:2.17.1 -> >=dev-java/log4j-core-2.17.1:2

CP_DEPEND="
	~dev-java/log4j-api-${PV}:2
	~dev-java/log4j-core-${PV}:2
"

# Compile dependencies
# POM: log4j-1.2-api/pom.xml
# org.jboss.spec.javax.jms:jboss-jms-api_1.1_spec:1.0.1.Final -> >=dev-java/jboss-jms-api-1.0.1:1.1
# POM: log4j-1.2-api/pom.xml
# test? com.fasterxml.jackson.dataformat:jackson-dataformat-xml:2.12.4 -> >=dev-java/jackson-dataformat-xml-2.13.0:0
# test? commons-io:commons-io:2.11.0 -> >=dev-java/commons-io-2.11.0:1
# test? org.apache.felix:org.apache.felix.framework:5.6.12 -> !!!groupId-not-found!!!
# test? org.apache.logging.log4j:log4j-api:2.17.1 -> >=dev-java/log4j-api-2.17.1:2
# test? org.apache.logging.log4j:log4j-core:2.17.1 -> >=dev-java/log4j-core-2.17.1:2
# test? org.apache.velocity:velocity:1.7 -> !!!artifactId-not-found!!!
# test? org.eclipse.tycho:org.eclipse.osgi:3.13.0.v20180226-1711 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-engine:5.7.2 -> !!!groupId-not-found!!!
# test? org.junit.vintage:junit-vintage-engine:5.7.2 -> !!!groupId-not-found!!!

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	dev-java/jboss-jms-api:1.1"
#	test? (
#		!!!artifactId-not-found!!!
#		!!!groupId-not-found!!!
#		>=dev-java/commons-io-2.11.0:1
#		>=dev-java/jackson-dataformat-xml-2.13.0:0
#		~dev-java/log4j-api-${PV}:2
#		~dev-java/log4j-core-${PV}:2
#	)
#"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README,RELEASE-NOTES,SECURITY}.md LICENSE.txt )

S="${WORKDIR}/apache-log4j-${PV}-src"

JAVA_CLASSPATH_EXTRA="jboss-jms-api-1.1"
JAVA_SRC_DIR="log4j-1.2-api/src/main/java"
JAVA_RESOURCE_DIRS=(
	"log4j-1.2-api/src/main/resources"
)

#	JAVA_TEST_GENTOO_CLASSPATH="jackson-dataformat-xml,commons-io-1,!!!groupId-not-found!!!,log4j-api-2,log4j-core-2,!!!artifactId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!"
#	JAVA_TEST_SRC_DIR="log4j-1.2-api/src/test/java"
#	JAVA_TEST_RESOURCE_DIRS=(
#		"log4j-1.2-api/src/test/resources"
#	)

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}

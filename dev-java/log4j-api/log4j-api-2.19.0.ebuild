# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom log4j-api/pom.xml --download-uri mirror://apache/logging/log4j/2.19.0/apache-log4j-2.19.0-src.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild log4j-api-2.19.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.logging.log4j:log4j-api:2.19.0"
JAVA_TESTING_FRAMEWORKS="junit-vintage junit-jupiter"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="The Apache Log4j API"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.tar.gz
	verify-sig? ( https://www.apache.org/dist/logging/log4j/${PV}/apache-log4j-${PV}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# junit-{jupiter,vintage} is not available in ::gentoo
RESTRICT="test"

# Compile dependencies
# POM: ${PN}/pom.xml
# org.osgi:org.osgi.core:6.0.0 -> !!!suitable-mavenVersion-not-found!!!
# POM: ${PN}/pom.xml
# test? com.fasterxml.jackson.core:jackson-core:2.13.4 -> >=dev-java/jackson-core-2.13.4:0
# test? com.fasterxml.jackson.core:jackson-databind:2.13.4 -> >=dev-java/jackson-databind-2.13.4:0
# test? org.apache.commons:commons-lang3:3.12.0 -> >=dev-java/commons-lang-3.12.0:3.6
# test? org.apache.felix:org.apache.felix.framework:7.0.5 -> >=dev-java/felix-framework-7.0.5:0
# test? org.apache.maven:maven-core:3.8.5 -> !!!groupId-not-found!!!
# test? org.assertj:assertj-core:3.23.1 -> !!!suitable-mavenVersion-not-found!!!
# test? org.eclipse.tycho:org.eclipse.osgi:3.13.0.v20180226-1711 -> !!!groupId-not-found!!!
# test? org.junit-pioneer:junit-pioneer:1.6.2 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-engine:5.9.0 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-migrationsupport:5.9.0 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-params:5.9.0 -> !!!groupId-not-found!!!
# test? org.junit.vintage:junit-vintage-engine:5.9.0 -> !!!groupId-not-found!!!
# test? uk.org.webcompere:system-stubs-jupiter:2.0.1 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/osgi-core:0"
#	test? (
#		!!!groupId-not-found!!!
#		!!!suitable-mavenVersion-not-found!!!
#		>=dev-java/commons-lang-3.12.0:3.6
#		>=dev-java/felix-framework-7.0.5:0
#		>=dev-java/jackson-core-2.13.4:0
#		>=dev-java/jackson-databind-2.13.4:0
#	)
#"

RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-apache-logging )
"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/logging.apache.org.asc"

DOCS=( {CONTRIBUTING,README,RELEASE-NOTES,SECURITY}.md )

S="${WORKDIR}/apache-log4j-${PV}-src"

JAVA_CLASSPATH_EXTRA="osgi-core"
JAVA_SRC_DIR="${PN}/src/main/java"
JAVA_RESOURCE_DIRS="${PN}/src/main/resources"

#	JAVA_TEST_GENTOO_CLASSPATH="jackson-core,jackson-databind,commons-lang-3.6,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!suitable-mavenVersion-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!"
#	JAVA_TEST_SRC_DIR="${PN}/src/test/java"
#	JAVA_TEST_RESOURCE_DIRS=(
#		"${PN}/src/test/resources"
#	)

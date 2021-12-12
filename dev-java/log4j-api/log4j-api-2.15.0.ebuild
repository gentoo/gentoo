# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom log4j-api/pom.xml --download-uri mirror://apache/logging/log4j/2.15.0/apache-log4j-2.15.0-src.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild log4j-api-2.15.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.logging.log4j:log4j-api:2.15.0"
JAVA_TESTING_FRAMEWORKS="junit-vintage junit-jupiter"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The Apache Log4j API"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# junit-{jupiter,vintage} is not available in ::gentoo
RESTRICT="test"

# Compile dependencies
# POM: ${PN}/pom.xml
# org.apache.logging.log4j:log4j-api-java9:2.15.0 -> >=dev-java/log4j-api-java9-2.15.0:2
# org.osgi:org.osgi.core:4.3.1 -> !!!artifactId-not-found!!!
# POM: ${PN}/pom.xml
# test? com.fasterxml.jackson.core:jackson-core:2.12.4 -> !!!groupId-not-found!!!
# test? com.fasterxml.jackson.core:jackson-databind:2.12.4 -> !!!groupId-not-found!!!
# test? org.apache.commons:commons-lang3:3.12.0 -> >=dev-java/commons-lang-3.12.0:3.6
# test? org.apache.felix:org.apache.felix.framework:5.6.12 -> !!!groupId-not-found!!!
# test? org.apache.maven:maven-core:3.6.3 -> !!!groupId-not-found!!!
# test? org.assertj:assertj-core:3.20.2 -> !!!suitable-mavenVersion-not-found!!!
# test? org.eclipse.tycho:org.eclipse.osgi:3.13.0.v20180226-1711 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-engine:5.7.2 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-migrationsupport:5.7.2 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-params:5.7.2 -> !!!groupId-not-found!!!
# test? org.junit.vintage:junit-vintage-engine:5.7.2 -> !!!groupId-not-found!!!

DEPEND=">=virtual/jdk-11:*
	dev-java/osgi-core-api:0
	dev-java/log4j-api-java9:2"
#	test? (
#		!!!groupId-not-found!!!
#		!!!suitable-mavenVersion-not-found!!!
#		>=dev-java/commons-lang-3.12.0:3.6
#	)
#"

RDEPEND=">=virtual/jre-11:*"

DOCS=( {CONTRIBUTING,README,RELEASE-NOTES,SECURITY}.md LICENSE.txt )

S="${WORKDIR}/apache-log4j-${PV}-src"

JAVA_CLASSPATH_EXTRA="log4j-api-java9-2,osgi-core-api"
JAVA_SRC_DIR="${PN}/src/main/java"
JAVA_RESOURCE_DIRS="${PN}/src/main/resources"

#	JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!,!!!groupId-not-found!!!,commons-lang-3.6,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!suitable-mavenVersion-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!"
#	JAVA_TEST_SRC_DIR="${PN}/src/test/java"
#	JAVA_TEST_RESOURCE_DIRS=(
#		"${PN}/src/test/resources"
#	)

src_prepare() {
	default
	mkdir -p log4j-api/src/main/resources/META-INF/versions/9 || die
	pushd log4j-api/src/main/resources/META-INF/versions/9 || die
		jar -xf "$(java-pkg_getjar --build-only log4j-api-java9-2 log4j-api-java9.jar)" \
			org/apache/logging/log4j/util module-info.class || die
		rm org/apache/logging/log4j/util/{PrivateSecurityManagerStackTraceUtil,PropertySource}.class || die
	popd || die
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom log4j-core/pom.xml --download-uri mirror://apache/logging/log4j/2.18.0/apache-log4j-2.18.0-src.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild log4j-core-2.18.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.logging.log4j:log4j-core:2.18.0"
# JAVA_TESTING_FRAMEWORKS="junit-vintage junit-jupiter"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The Apache Log4j Implementation"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# We don't have junit-vintage and junit-jupiter
RESTRICT="test"

# Common dependencies
# POM: ${PN}/pom.xml
# com.conversantmedia:disruptor:1.2.15 -> >=dev-java/conversant-disruptor-1.2.19:0
# com.fasterxml.jackson.core:jackson-core:2.13.3 -> >=dev-java/jackson-core-2.13.3:0
# com.fasterxml.jackson.core:jackson-databind:2.13.3 -> >=dev-java/jackson-databind-2.13.3:0
# com.fasterxml.jackson.dataformat:jackson-dataformat-xml:2.13.3 -> >=dev-java/jackson-dataformat-xml-2.13.3:0
# com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:2.13.3 -> >=dev-java/jackson-dataformat-yaml-2.13.3:0
# com.fasterxml.woodstox:woodstox-core:6.2.8 -> >=dev-java/woodstox-core-6.2.8:0
# com.lmax:disruptor:3.4.4 -> >=dev-java/lmax-disruptor-3.4.4:0
# org.apache.commons:commons-compress:1.21 -> >=dev-java/commons-compress-1.21:0
# org.apache.commons:commons-csv:1.9.0 -> >=dev-java/commons-csv-1.9.0:0
# org.apache.kafka:kafka-clients:1.1.1 -> >=dev-java/kafka-clients-1.1.1:0
# org.apache.logging.log4j:log4j-api:2.18.0 -> >=dev-java/log4j-api-2.18.0:2
# org.fusesource.jansi:jansi:2.4.0 -> >=dev-java/jansi-2.4.0:2
# org.jctools:jctools-core:3.3.0 -> !!!suitable-mavenVersion-not-found!!!
# org.slf4j:slf4j-api:1.7.36 -> >=dev-java/slf4j-api-1.7.36:0
# org.zeromq:jeromq:0.5.2 -> >=dev-java/jeromq-0.5.2:0

CP_DEPEND="
	dev-java/commons-compress:0
	dev-java/commons-csv:0
	dev-java/conversant-disruptor:0
	dev-java/jackson-core:0
	dev-java/jackson-databind:0
	dev-java/jackson-dataformat-xml:0
	dev-java/jackson-dataformat-yaml:0
	dev-java/jansi:2
	dev-java/javax-mail:0
	dev-java/jctools-core:3
	dev-java/jeromq:0
	dev-java/kafka-clients:0
	dev-java/lmax-disruptor:0
	~dev-java/log4j-api-${PV}:2
	dev-java/slf4j-api:0
	dev-java/woodstox-core:0
"

# Compile dependencies
# POM: ${PN}/pom.xml
# javax.activation:javax.activation-api:1.2.0 -> !!!groupId-not-found!!!
# javax.jms:javax.jms-api:2.0.1 -> !!!groupId-not-found!!!
# javax.mail:javax.mail-api:1.6.2 -> !!!groupId-not-found!!!
# org.osgi:org.osgi.core:6.0.0 -> >=dev-java/osgi-core-8.0.0:0
# POM: ${PN}/pom.xml
# test? ch.qos.logback:logback-classic:1.2.11 -> >=dev-java/logback-classic-1.2.11:0
# test? ch.qos.logback:logback-core:1.2.11 -> >=dev-java/logback-core-1.2.11:0
# test? com.github.tomakehurst:wiremock:2.26.3 -> !!!groupId-not-found!!!
# test? com.google.code.java-allocation-instrumenter:java-allocation-instrumenter:3.3.0 -> !!!groupId-not-found!!!
# test? com.h2database:h2:2.1.214 -> !!!groupId-not-found!!!
# test? commons-codec:commons-codec:1.15 -> >=dev-java/commons-codec-1.15:0
# test? commons-io:commons-io:2.11.0 -> >=dev-java/commons-io-2.11.0:1
# test? commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0
# test? net.javacrumbs.json-unit:json-unit:2.32.0 -> !!!groupId-not-found!!!
# test? org.apache-extras.beanshell:bsh:2.0b6 -> >=dev-java/bsh-2.0_beta6:0
# test? org.apache.activemq:activemq-broker:5.17.1 -> !!!groupId-not-found!!!
# test? org.apache.commons:commons-lang3:3.12.0 -> >=dev-java/commons-lang-3.12.0:3.6
# test? org.apache.felix:org.apache.felix.framework:7.0.5 -> !!!groupId-not-found!!!
# test? org.apache.logging.log4j:log4j-api:2.18.0 -> >=dev-java/log4j-api-2.18.0:2
# test? org.apache.maven:maven-core:3.8.5 -> !!!groupId-not-found!!!
# test? org.awaitility:awaitility:4.2.0 -> !!!groupId-not-found!!!
# test? org.codehaus.groovy:groovy-dateutil:3.0.10 -> !!!groupId-not-found!!!
# test? org.codehaus.groovy:groovy-jsr223:3.0.10 -> !!!groupId-not-found!!!
# test? org.codehaus.plexus:plexus-utils:3.4.2 -> !!!groupId-not-found!!!
# test? org.eclipse.tycho:org.eclipse.osgi:3.13.0.v20180226-1711 -> !!!groupId-not-found!!!
# test? org.hamcrest:hamcrest:2.2 -> >=dev-java/hamcrest-2.2:0
# test? org.hsqldb:hsqldb:2.5.2 -> !!!groupId-not-found!!!
# test? org.jmdns:jmdns:3.5.7 -> !!!groupId-not-found!!!
# test? org.junit-pioneer:junit-pioneer:1.6.2 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-engine:5.8.2 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-params:5.8.2 -> !!!groupId-not-found!!!
# test? org.junit.platform:junit-platform-commons:1.8.2 -> !!!groupId-not-found!!!
# test? org.junit.vintage:junit-vintage-engine:5.8.2 -> !!!groupId-not-found!!!
# test? org.mockito:mockito-core:4.4.0 -> >=dev-java/mockito-4.4.0:4
# test? org.mockito:mockito-junit-jupiter:4.4.0 -> !!!artifactId-not-found!!!
# test? org.slf4j:slf4j-ext:1.7.36 -> >=dev-java/slf4j-ext-1.7.36:0
# test? org.springframework:spring-test:5.3.20 -> !!!groupId-not-found!!!
# test? org.tukaani:xz:1.9 -> >=dev-java/xz-java-1.9:0
# test? org.xmlunit:xmlunit-core:2.9.0 -> !!!groupId-not-found!!!
# test? org.xmlunit:xmlunit-matchers:2.9.0 -> !!!groupId-not-found!!!
# test? org.zapodot:embedded-ldap-junit:0.8.1 -> !!!groupId-not-found!!!

DEPEND="${CP_DEPEND}
	dev-java/jakarta-activation-api:1
	dev-java/jakarta-mail-api:0
	dev-java/javax-jms-api:0
	dev-java/osgi-core:0
	>=virtual/jdk-1.8:*"
#	test? (
#		!!!artifactId-not-found!!!
#		!!!groupId-not-found!!!
#		>=dev-java/bsh-2.0_beta6:0
#		>=dev-java/commons-codec-1.15:0
#		>=dev-java/commons-io-2.11.0:1
#		>=dev-java/commons-lang-3.12.0:3.6
#		>=dev-java/commons-logging-1.2:0
#		>=dev-java/hamcrest-2.2:0
#		>=dev-java/log4j-api-2.18.0:2
#		>=dev-java/logback-classic-1.2.11:0
#		>=dev-java/logback-core-1.2.11:0
#		>=dev-java/mockito-4.4.0:4
#		>=dev-java/slf4j-ext-1.7.36:0
#		>=dev-java/xz-java-1.9:0
#	)
#"

# Runtime dependencies
# POM: ${PN}/pom.xml
# com.sun.mail:javax.mail:1.6.2 -> !!!artifactId-not-found!!!

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( {CONTRIBUTING,README,RELEASE-NOTES,SECURITY}.md )

S="${WORKDIR}/apache-log4j-${PV}-src"

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-1,jakarta-mail-api,javax-jms-api,osgi-core"
JAVA_SRC_DIR="${PN}/src/main/java"
JAVA_RESOURCE_DIRS="${PN}/src/main/resources"

#JAVA_TEST_GENTOO_CLASSPATH="logback-classic,logback-core,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,commons-codec,commons-io-1,commons-logging,!!!groupId-not-found!!!,bsh,!!!groupId-not-found!!!,commons-lang-3.6,!!!groupId-not-found!!!,log4j-api-2,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,hamcrest,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,mockito-4,!!!artifactId-not-found!!!,slf4j-ext,!!!groupId-not-found!!!,xz-java,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!"
#JAVA_TEST_SRC_DIR="${PN}/src/test/java"
#JAVA_TEST_RESOURCE_DIRS=(
#	"${PN}/src/test/resources"
#)

src_compile() {
	java-pkg-simple_src_compile

	# Process the @Plugin annotation used on Log4j 2 built-in plugins
	# to generate a serialized plugin listing file
	# https://logging.apache.org/log4j/2.x/manual/plugins.html
	local processor="org.apache.logging.log4j.core.config.plugins.processor.PluginProcessor"
	local classes="target/classes"
	local classpath="${JAVA_JAR_FILENAME}:$(\
		java-pkg_getjars --build-only --with-dependencies \
		"${JAVA_GENTOO_CLASSPATH},${JAVA_CLASSPATH_EXTRA}")"
	# Just in case java-pkg-simple.eclass changes the path in the future
	mkdir -p "${classes}" || die "Failed to create directory for classes"
	local sources_list_file="${T}/sources.lst"
	find "${JAVA_SRC_DIR}" -type f -name "*.java" > "${sources_list_file}" || die
	ejavac -d "${classes}" -cp "${classpath}" \
		-proc:only -processor "${processor}" \
		@"${sources_list_file}"
	# Update the JAR to include the serialized plugin listing file
	local jar="$(java-config -j)"
	"${jar}" -uf "${JAVA_JAR_FILENAME}" -C "${classes}" . ||
		die "Failed to update JAR"
}

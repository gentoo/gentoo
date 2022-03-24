# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom log4j-core/pom.xml --download-uri mirror://apache/logging/log4j/2.17.1/apache-log4j-2.17.1-src.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild log4j-core-2.17.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.logging.log4j:log4j-core:2.17.1"
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
# com.fasterxml.jackson.core:jackson-core:2.12.4 -> >=dev-java/jackson-core-2.13.0:0
# com.fasterxml.jackson.core:jackson-databind:2.12.4 -> >=dev-java/jackson-databind-2.13.0:0
# com.fasterxml.jackson.dataformat:jackson-dataformat-xml:2.12.4 -> >=dev-java/jackson-dataformat-xml-2.13.0:0
# com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:2.12.4 -> >=dev-java/jackson-dataformat-yaml-2.13.0:0
# com.fasterxml.woodstox:woodstox-core:6.2.6 -> >=dev-java/woodstox-core-6.2.7:0
# com.lmax:disruptor:3.4.4 -> >=dev-java/lmax-disruptor-3.4.4:0
# com.sun.mail:javax.mail:1.6.2 -> >=dev-java/javax-mail-1.6.2:0
# org.apache.commons:commons-compress:1.21 -> >=dev-java/commons-compress-1.21:0
# org.apache.commons:commons-csv:1.9.0 -> >=dev-java/commons-csv-1.9.0:0
# org.apache.kafka:kafka-clients:1.1.1 -> >=dev-java/kafka-clients-1.1.1:0
# org.apache.logging.log4j:log4j-api:2.17.1 -> >=dev-java/log4j-api-2.17.1:2
# org.fusesource.jansi:jansi:2.3.4 -> >=dev-java/jansi-2.4.0:2
# org.jctools:jctools-core:1.2.1 -> >=dev-java/jctools-core-2.0.2:0
# org.slf4j:slf4j-api:1.7.25 -> >=dev-java/slf4j-api-1.7.30:0
# org.zeromq:jeromq:0.4.3 -> >=dev-java/jeromq-0.5.2:0

CP_DEPEND="
	dev-java/commons-compress:0
	dev-java/commons-csv:0
	dev-java/conversant-disruptor:0
	dev-java/jackson-core:0
	dev-java/jackson-databind:0
	dev-java/jackson-dataformat-xml:0
	dev-java/jackson-dataformat-yaml:0
	dev-java/jakarta-activation-api:1
	dev-java/jansi:2
	dev-java/javax-mail:0
	dev-java/jctools-core:0
	dev-java/jeromq:0
	dev-java/kafka-clients:0
	dev-java/lmax-disruptor:0
	~dev-java/log4j-api-${PV}:2
	dev-java/slf4j-api:0
	dev-java/woodstox-core:0
"

# Compile dependencies
# POM: ${PN}/pom.xml
# org.jboss.spec.javax.jms:jboss-jms-api_1.1_spec:1.0.1.Final -> >=dev-java/jboss-jms-api-1.0.1:1.1
# org.osgi:org.osgi.core:4.3.1 -> >=dev-java/osgi-core-api-5.0.0:0
# POM: ${PN}/pom.xml
# test? ch.qos.logback:logback-classic:1.2.3 -> !!!groupId-not-found!!!
# test? ch.qos.logback:logback-core:1.2.3 -> !!!groupId-not-found!!!
# test? com.github.tomakehurst:wiremock:2.26.3 -> !!!groupId-not-found!!!
# test? com.google.code.java-allocation-instrumenter:java-allocation-instrumenter:3.0.1 -> !!!groupId-not-found!!!
# test? com.h2database:h2:1.4.200 -> !!!groupId-not-found!!!
# test? commons-codec:commons-codec:1.15 -> >=dev-java/commons-codec-1.15:0
# test? commons-io:commons-io:2.11.0 -> >=dev-java/commons-io-2.11.0:1
# test? commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0
# test? log4j:log4j:1.2.17 -> >=dev-java/log4j-1.2.17:0
# test? net.javacrumbs.json-unit:json-unit:2.27.0 -> !!!groupId-not-found!!!
# test? org.apache-extras.beanshell:bsh:2.0b6 -> >=dev-java/bsh-2.0_beta6:0
# test? org.apache.activemq:activemq-broker:5.16.3 -> !!!groupId-not-found!!!
# test? org.apache.commons:commons-lang3:3.12.0 -> >=dev-java/commons-lang-3.12.0:3.6
# test? org.apache.felix:org.apache.felix.framework:5.6.12 -> !!!groupId-not-found!!!
# test? org.apache.logging.log4j:log4j-api:2.17.1 -> >=dev-java/log4j-api-2.17.1:2
# test? org.apache.maven:maven-core:3.6.3 -> !!!groupId-not-found!!!
# test? org.awaitility:awaitility:4.0.3 -> !!!groupId-not-found!!!
# test? org.codehaus.groovy:groovy-dateutil:3.0.8 -> !!!groupId-not-found!!!
# test? org.codehaus.groovy:groovy-jsr223:3.0.8 -> !!!groupId-not-found!!!
# test? org.codehaus.plexus:plexus-utils:3.4.0 -> !!!groupId-not-found!!!
# test? org.eclipse.tycho:org.eclipse.osgi:3.13.0.v20180226-1711 -> !!!groupId-not-found!!!
# test? org.hamcrest:hamcrest:2.2 -> !!!artifactId-not-found!!!
# test? org.hdrhistogram:HdrHistogram:2.1.9 -> !!!groupId-not-found!!!
# test? org.hsqldb:hsqldb:2.5.2 -> !!!groupId-not-found!!!
# test? org.jmdns:jmdns:3.5.7 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-engine:5.7.2 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-params:5.7.2 -> !!!groupId-not-found!!!
# test? org.junit.vintage:junit-vintage-engine:5.7.2 -> !!!groupId-not-found!!!
# test? org.mockito:mockito-core:3.11.2 -> !!!suitable-mavenVersion-not-found!!!
# test? org.mockito:mockito-junit-jupiter:3.11.2 -> !!!artifactId-not-found!!!
# test? org.slf4j:slf4j-ext:1.7.25 -> !!!artifactId-not-found!!!
# test? org.springframework:spring-test:5.3.13 -> !!!groupId-not-found!!!
# test? org.tukaani:xz:1.9 -> >=dev-java/xz-java-1.9:0
# test? org.xmlunit:xmlunit-core:2.8.3 -> !!!groupId-not-found!!!
# test? org.xmlunit:xmlunit-matchers:2.8.3 -> !!!groupId-not-found!!!
# test? org.zapodot:embedded-ldap-junit:0.8.1 -> !!!groupId-not-found!!!

DEPEND="${CP_DEPEND}
	dev-java/jboss-jms-api:1.1
	dev-java/osgi-core-api:0
	>=virtual/jdk-1.8:*"
#	test? (
#		!!!artifactId-not-found!!!
#		!!!groupId-not-found!!!
#		!!!suitable-mavenVersion-not-found!!!
#		>=dev-java/bsh-2.0_beta6:0
#		>=dev-java/commons-codec-1.15:0
#		>=dev-java/commons-io-2.11.0:1
#		>=dev-java/commons-lang-3.12.0:3.6
#		>=dev-java/commons-logging-1.2:0
#		>=dev-java/log4j-1.2.17:0
#		~dev-java/log4j-api-${PV}:2
#		>=dev-java/xz-java-1.9:0
#	)
#"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( {CONTRIBUTING,README,RELEASE-NOTES,SECURITY}.md LICENSE.txt )

S="${WORKDIR}/apache-log4j-${PV}-src"

JAVA_CLASSPATH_EXTRA="jboss-jms-api-1.1,osgi-core-api"
JAVA_SRC_DIR="${PN}/src/main/java"
JAVA_RESOURCE_DIRS=(
	"${PN}/src/main/resources"
)

#	JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,commons-codec,commons-io-1,commons-logging,log4j,!!!groupId-not-found!!!,bsh,!!!groupId-not-found!!!,commons-lang-3.6,!!!groupId-not-found!!!,log4j-api-2,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!artifactId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!suitable-mavenVersion-not-found!!!,!!!artifactId-not-found!!!,!!!artifactId-not-found!!!,!!!groupId-not-found!!!,xz-java,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!"
#	JAVA_TEST_SRC_DIR="${PN}/src/test/java"
#	JAVA_TEST_RESOURCE_DIRS=(
#		"${PN}/src/test/resources"
#	)

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
	ejavac -d "${classes}" -cp "${classpath}" \
		-proc:only -processor "${processor}" \
		$(find "${JAVA_SRC_DIR}" -name "*.java")
	# Update the JAR to include the serialized plugin listing file
	local jar="$(java-config -j)"
	"${jar}" -uf "${JAVA_JAR_FILENAME}" -C "${classes}" . ||
		die "Failed to update JAR"
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}

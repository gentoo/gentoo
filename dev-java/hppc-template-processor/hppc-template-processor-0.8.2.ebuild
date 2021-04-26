# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/carrotsearch/hppc/archive/refs/tags/0.8.2.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild hppc-template-processor-0.8.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.carrotsearch:hppc-template-processor:0.8.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Template Processor and Code Generation for HPPC."
HOMEPAGE="http://labs.carrotsearch.com/hppc.html/hppc-template-processor"
SRC_URI="https://github.com/carrotsearch/hppc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Common dependencies
# POM: pom.xml
# com.google.guava:guava:18.0 -> >=dev-java/guava-20.0:20
# junit:junit:4.12 -> >=dev-java/junit-4.12:4
# org.antlr:antlr4:4.7.1 -> >=dev-java/antlr-4.5.3:4
# org.apache.maven:maven-core:3.2.3 -> !!!groupId-not-found!!!
# org.apache.maven:maven-plugin-api:3.2.3 -> !!!groupId-not-found!!!
# org.apache.velocity:velocity-engine-core:2.0 -> >=dev-java/velocity-2.3:0

#	CDEPEND="
#		!!!groupId-not-found!!!
#		>=dev-java/antlr-4.5.3:4
#		>=dev-java/guava-20.0:20
#		>=dev-java/junit-4.12:4
#		>=dev-java/velocity-2.3:0
#	"
CDEPEND="
	>=dev-java/antlr-4.5.3:4
	>=dev-java/guava-20.0:20
	>=dev-java/junit-4.12:4
	>=dev-java/velocity-2.3:0
"

# Compile dependencies
# POM: pom.xml
# org.apache.maven.plugin-tools:maven-plugin-annotations:3.4 -> !!!groupId-not-found!!!
# POM: pom.xml
# test? com.carrotsearch.randomizedtesting:randomizedtesting-runner:2.6.1 -> >=dev-java/randomized-runner-2.7.8:0
# test? org.assertj:assertj-core:2.0.0 -> >=dev-java/assertj-core-2.3.0:2

#	DEPEND="
#		>=virtual/jdk-1.8:*
#		${CDEPEND}
#		!!!groupId-not-found!!!
#		test? (
#			>=dev-java/assertj-core-2.3.0:2
#			>=dev-java/randomized-runner-2.7.8:0
#		)
#	"
DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		>=dev-java/assertj-core-2.3.0:2
		>=dev-java/randomized-runner-2.7.8:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/hppc-${PV}/${PN}"

#	JAVA_GENTOO_CLASSPATH="guava-20,junit-4,antlr-4,!!!groupId-not-found!!!,!!!groupId-not-found!!!,velocity"
JAVA_GENTOO_CLASSPATH="guava-20,junit-4,antlr-4,velocity"
#	JAVA_CLASSPATH_EXTRA="!!!groupId-not-found!!!"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="randomized-runner,assertj-core-2"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default

# atn = false
# forceATN = false
# generateTestSources = false
# inputEncoding = UTF-8
# libDirectory = /var/tmp/portage/dev-java/hppc-template-processor-0.8.2/work/hppc-0.8.2/hppc-template-processor/src/main/antlr4/imports
# listener = true
# outputDirectory = /var/tmp/portage/dev-java/hppc-template-processor-0.8.2/work/hppc-0.8.2/hppc-template-processor/target/generated-sources/antlr4
# outputEncoding = UTF-8
# project = MavenProject: com.carrotsearch:hppc-template-processor:0.8.2 @ /var/tmp/portage/dev-java/hppc-template-processor-0.8.2/work/hppc-0.8.2/hppc-template-processor/pom.xml
# sourceDirectory = /var/tmp/portage/dev-java/hppc-template-processor-0.8.2/work/hppc-0.8.2/hppc-template-processor/src/main/antlr4
# statusDirectory = /var/tmp/portage/dev-java/hppc-template-processor-0.8.2/work/hppc-0.8.2/hppc-template-processor/target/maven-status/antlr4
# treatWarningsAsErrors = false
# visitor = true

	echo "$(pwd)"

	antlr4 \
		-atn false \
		-Xforce-atn false \
		-encoding UTF-8 \
		-lib src/main/antlr4/imports \
		-listener true \
		-o target/generated-sources/antlr4 \
		-package MavenProject: pom.xml
		-Werror false \
		-visitor true
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="The Apache Log4j API"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.zip
	verify-sig? ( mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.zip.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# LoggerTest.java:25: error: package org.apache.logging.log4j.core.test.appender does not exist
# LoggerTest.java:26: error: package org.apache.logging.log4j.core.test.junit does not exist
# CallerInformationTest.java:25: error: package org.apache.logging.log4j.core.test.appender does not exist
# CallerInformationTest.java:26: error: package org.apache.logging.log4j.core.test.junit does not exist
RESTRICT="test"

BDEPEND="
	app-arch/unzip
	verify-sig? ( >=sec-keys/openpgp-keys-apache-logging-20251104 )
"

CP_DEPEND="
	>=dev-java/bnd-annotation-7.1.0:0
	>=dev-java/commons-logging-1.3.5-r1:0
	~dev-java/log4j-api-${PV}:0
	>=dev-java/osgi-annotation-8.1.0:0
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/jakarta-servlet-api-4.0.4:4
	>=dev-java/jspecify-1.0.0:0
	>=dev-java/osgi-core-8.0.0:0
	>=dev-java/slf4j-api-2.0.3:0
	>=virtual/jdk-11:*
	test? (
		>=dev-java/assertj-core-3.27.6:0
		dev-java/asm:0
		dev-java/brotli-dec:0
		dev-java/commons-codec:0
		dev-java/commons-compress:0
		dev-java/commons-csv:0
		dev-java/commons-io:0
		dev-java/commons-lang:0
		dev-java/conversant-disruptor:0
		dev-java/jackson-annotations:0
		dev-java/jackson-core:0
		dev-java/jackson-databind:0
		dev-java/jackson-dataformat-xml:0
		dev-java/jackson-dataformat-yaml:0
		dev-java/jakarta-activation-api:1
		dev-java/javax-jms-api:0
		dev-java/javax-mail:0
		dev-java/jctools-core:0
		dev-java/jeromq:0
		dev-java/jnacl:0
		dev-java/kafka-clients:0
		dev-java/lmax-disruptor:0
		~dev-java/log4j-core-${PV}:0
		dev-java/snakeyaml:0
		dev-java/stax2-api:0
		dev-java/xz-java:0
		dev-java/zstd-jni:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="jakarta-servlet-api-4 jspecify osgi-core slf4j-api"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.logging.log4j.jcl"
JAVA_MODULE_INFO_OUT="log4j-jcl-java9/src/main/java"
JAVA_RELEASE_SRC_DIRS=( ["9"]="log4j-jcl-java9/src/main/java" )
JAVA_RESOURCE_DIRS="log4j-jcl/src/main/resources"
JAVA_SRC_DIR="log4j-jcl/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm assertj-core brotli-dec commons-codec commons-compress
	commons-csv commons-io commons-lang conversant-disruptor jackson-annotations
	jackson-core jackson-databind jackson-dataformat-xml jackson-dataformat-yaml
	jakarta-activation-api-1 javax-jms-api javax-mail jctools-core jeromq jnacl
	kafka-clients lmax-disruptor log4j-core snakeyaml stax2-api xz-java zstd-jni"
JAVA_TEST_RESOURCE_DIRS="log4j-jcl/src/test/resources"
JAVA_TEST_SRC_DIR="log4j-jcl/src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/logging.apache.org.asc"

src_compile() {
	java-pkg-simple_src_compile
	# Upstream places module-info in root of the jar.
	mv target/classes/{META-INF/versions/9/,}module-info.class || die
	rm -r target/classes/META-INF/versions log4j-jcl.jar || die
	jar cf log4j-jcl.jar -C target/classes . || die
}

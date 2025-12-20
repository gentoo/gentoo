# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, too many test-dependencies are not packaged.
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="The Apache Log4j Implementation"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.zip
	verify-sig? ( https://downloads.apache.org/logging/log4j/${PV}/apache-log4j-${PV}-src.zip.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="
	app-arch/unzip
	verify-sig? ( >=sec-keys/openpgp-keys-apache-logging-20251104 )
"
CP_DEPEND="
	>=dev-java/bnd-annotation-7.1.0:0
	>=dev-java/commons-compress-1.28.0:0
	>=dev-java/commons-csv-1.14.1-r1:0
	>=dev-java/conversant-disruptor-1.2.20:0
	>=dev-java/findbugs-annotations-3.0.1:0
	>=dev-java/jackson-annotations-2.20:0
	>=dev-java/jackson-core-2.20.0:0
	>=dev-java/jackson-databind-2.20.0:0
	>=dev-java/jackson-dataformat-xml-2.20.0:0
	>=dev-java/jackson-dataformat-yaml-2.20.0:0
	>=dev-java/javax-mail-1.6.7-r2:0
	>=dev-java/jctools-core-4.0.5-r1:0
	>=dev-java/jeromq-0.6.0-r1:0
	>=dev-java/javax-jms-api-2.0.3:0
	>=dev-java/jspecify-1.0.0:0
	>=dev-java/kafka-clients-1.1.1-r2:0
	>=dev-java/lmax-disruptor-3.4.4:0
	~dev-java/log4j-api-${PV}:0
	>=dev-java/osgi-annotation-8.1.0:0
	>=dev-java/osgi-core-8.0.0:0
	>=dev-java/stax2-api-4.2.2:0
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/asm-9.9:0
	>=dev-java/brotli-dec-0.1.2-r1:0
	>=dev-java/commons-codec-1.19.0:0
	>=dev-java/commons-io-2.20.0:0
	>=dev-java/commons-lang-3.19.0:0
	>=dev-java/jakarta-activation-api-1.2.2-r1:1
	>=dev-java/jnacl-1.0-r1:0
	>=dev-java/snakeyaml-2.5:0
	>=dev-java/xz-java-1.10:0
	>=dev-java/zstd-jni-1.5.7.4:0
	>=virtual/jdk-9:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="asm brotli-dec commons-codec commons-io
	commons-lang jakarta-activation-api-1 jnacl snakeyaml xz-java zstd-jni"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.logging.log4j.core"
JAVA_MODULE_INFO_OUT="log4j-core-java9/src/main/java"
JAVA_RELEASE_SRC_DIRS=( ["9"]="log4j-core-java9/src/main/java" )
JAVA_RESOURCE_DIRS="${PN}/src/main/resources"
JAVA_SRC_DIR="${PN}/src/main/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/logging.apache.org.asc"

src_prepare() {
	java-pkg-2_src_prepare
	# according to what we get from grep -nr '@ServiceProvider' log4j-core/*

	mkdir -p log4j-core/src/main/resources/META-INF/services || die "mkdir"
	pushd $_ >/dev/null || die "pushd"
	echo "org.apache.logging.log4j.core.config.plugins.processor.GraalVmProcessor" \
		> javax.annotation.processing.Processor || die
	echo "org.apache.logging.log4j.core.config.plugins.processor.PluginProcessor" \
		>> javax.annotation.processing.Processor || die
	echo "org.apache.logging.log4j.core.impl.ThreadContextDataProvider" \
		> org.apache.logging.log4j.core.util.ContextDataProvider || die
	echo "org.apache.logging.log4j.core.message.ExtendedThreadInfoFactory" \
		> 'org.apache.logging.log4j.message.ThreadDumpMessage$ThreadInfoFactory' || die
	echo "org.apache.logging.log4j.core.impl.Log4jProvider" \
		> org.apache.logging.log4j.spi.Provider || die
	popd >/dev/null || die popd
}

src_compile() {
	# we run this twice, first time to get PluginProcessor into processorpath.
	java-pkg-simple_src_compile

	# using PluginProcessor.class
	JAVAC_ARGS=" -processorpath target/classes:$(java-pkg_getjars log4j-api) \
		-processor org.apache.logging.log4j.core.config.plugins.processor.PluginProcessor"
	java-pkg-simple_src_compile

	# For versions/9, upstream packages only what's listed in log4j-core-java9/src/assembly/java9.xml
	# We remove the jar, remove from target/classes what's not needed and re-create the jar.
	rm log4j-core.jar || die
	rm -r target/classes/META-INF/versions/9/org/apache/logging/log4j/core/pattern || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/core/util/Integers.class || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/core/impl/ExtendedClassInfo.class || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/core/jackson/StackTraceElementConstants.class || die
	mv target/classes/{META-INF/versions/9/,}module-info.class || die
	echo 'Multi-Release: true' >> target/classes/META-INF/MANIFEST.MF || die "add true"
	jar cfm log4j-core.jar target/classes/META-INF/MANIFEST.MF -C target/classes . || die
}

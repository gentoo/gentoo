# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="The Apache Log4j 1.x Compatibility API"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.zip
	verify-sig? ( https://downloads.apache.org/logging/log4j/${PV}/apache-log4j-${PV}-src.zip.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
RESTRICT="test"	# Too many test-dependencies not packaged.

BDEPEND="
	app-arch/unzip
	verify-sig? ( >=sec-keys/openpgp-keys-apache-logging-20251104 )
"

CP_DEPEND="
	dev-java/javax-jms-api:0
	~dev-java/log4j-api-${PV}:0
	~dev-java/log4j-core-${PV}:0
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/asm-9.9:0
	>=dev-java/brotli-dec-0.1.2-r1:0
	>=dev-java/commons-codec-1.19.0:0
	>=dev-java/commons-compress-1.28.0:0
	>=dev-java/commons-csv-1.14.1-r1:0
	>=dev-java/commons-io-2.20.0:0
	>=dev-java/commons-lang-3.19.0:0
	>=dev-java/conversant-disruptor-1.2.20:0
	>=dev-java/jackson-annotations-2.20:0
	>=dev-java/jackson-core-2.20.0:0
	>=dev-java/jackson-databind-2.20.0:0
	>=dev-java/jackson-dataformat-xml-2.20.0:0
	>=dev-java/jackson-dataformat-yaml-2.20.0:0
	>=dev-java/jakarta-activation-2.0.1-r1:2
	>=dev-java/jakarta-mail-2.0.1:0
	>=dev-java/jctools-core-4.0.5-r1:0
	>=dev-java/jeromq-0.6.0-r1:0
	>=dev-java/jnacl-1.0-r1:0
	>=dev-java/jspecify-1.0.0:0
	>=dev-java/kafka-clients-1.1.1-r2:0
	>=dev-java/lmax-disruptor-3.4.4:0
	>=dev-java/osgi-core-8.0.0:0
	>=dev-java/snakeyaml-2.5:0
	>=dev-java/stax2-api-4.2.2:0
	>=dev-java/xz-java-1.10:0
	>=dev-java/zstd-jni-1.5.7.4:0
	>=virtual/jdk-11:*
"

RDEPEND="
	${CP_DEPEND}
	>=dev-java/bnd-annotation-7.1.0:0
	>=dev-java/osgi-annotation-8.1.0:0
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="
	asm
	brotli-dec
	commons-codec
	commons-compress
	commons-csv
	commons-io
	commons-lang
	conversant-disruptor
	jackson-annotations
	jackson-core
	jackson-databind
	jackson-dataformat-xml
	jackson-dataformat-yaml
	jakarta-activation-2
	jakarta-mail
	jctools-core
	jeromq
	jnacl
	jspecify
	kafka-clients
	lmax-disruptor
	osgi-core
	snakeyaml
	stax2-api
	xz-java
	zstd-jni
"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.log4j"
JAVA_MODULE_INFO_OUT="log4j-1.2-api-java9/src/main/java"
JAVA_RELEASE_SRC_DIRS=( ["9"]="log4j-1.2-api-java9/src/main/java" )
JAVA_RESOURCE_DIRS="log4j-1.2-api/src/main/resources"
JAVA_SRC_DIR="log4j-1.2-api/src/main/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/logging.apache.org.asc"

src_install() {
	# Upstream puts module-info.class at the root of the jar.
	rm log4j-12-api.jar || die
	mv target/classes/{META-INF/versions/9/,}module-info.class || die
	echo 'Multi-Release: false' >> target/classes/META-INF/MANIFEST.MF || die "add false"
	jar cfm log4j-12-api.jar target/classes/META-INF/MANIFEST.MF -C target/classes . || die

	java-pkg-simple_src_install
	java-pkg_register-dependency bnd-annotation,osgi-annotation
}

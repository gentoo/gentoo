# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-compress:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Java API for working with archive files"
HOMEPAGE="https://commons.apache.org/proper/commons-compress/"
PEV="4.13.5"
AAV="2.0.2"
SRC_URI="mirror://apache/commons/compress/source/${P}-src.tar.gz
	test? (
		https://repo1.maven.org/maven2/org/ops4j/pax/exam/pax-exam/${PEV}/pax-exam-${PEV}.jar
		https://repo1.maven.org/maven2/org/ops4j/pax/exam/pax-exam-junit4/${PEV}/pax-exam-junit4-${PEV}.jar
		https://repo1.maven.org/maven2/io/airlift/aircompressor/${AAV}/aircompressor-${AAV}.jar
	)
	verify-sig? ( https://downloads.apache.org/commons/compress/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ggregory )"

CP_DEPEND="
	>=dev-java/asm-9.8-r1:0
	dev-java/brotli-dec:0
	>=dev-java/commons-codec-1.19.0:0
	>=dev-java/commons-io-2.20.0:0
	>=dev-java/commons-lang-3.18.0:0
	>=dev-java/xz-java-1.10:0
	>=dev-java/zstd-jni-1.5.7.4:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	dev-java/osgi-core:0
	test? (
		dev-java/javax-inject:0
		dev-java/junit-pioneer:0
		dev-java/junit:4
		dev-java/memoryfilesystem:0
		dev-java/mockito:4
		dev-java/opentest4j:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.compress"
JAVA_CLASSPATH_EXTRA="osgi-core"
JAVA_GENTOO_CLASSPATH_EXTRA+=:"${DISTDIR}/aircompressor-${AAV}.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=:"${DISTDIR}/pax-exam-${PEV}.jar:${DISTDIR}/pax-exam-junit4-${PEV}.jar"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MAIN_CLASS="org.apache.commons.compress.archivers.Lister"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="javax-inject junit-pioneer junit-4 junit-5 memoryfilesystem mockito-4 opentest4j"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ggregory.asc"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.gz{,.asc}
	default
}

src_prepare() {
	java-pkg-2_src_prepare

	tar xfv src/test/resources/zstd-tests.tar -C src/test/resources || die "untar"

	# error: package shaded.org.apache.commons.lang3 does not exist
	rm src/test/java/org/apache/commons/compress/archivers/tar/TarFileTest.java || die
	rm src/test/java/org/apache/commons/compress/archivers/TarTest.java || die

	# error: package shaded.org.apache.commons.io does not exist
	rm src/test/java/org/apache/commons/compress/archivers/zip/Zip64SupportIT.java || die
	rm src/test/java/org/apache/commons/compress/compressors/gzip/GzipCompressorOutputStreamTest.java || die

	# error: package org.mockito.junit.jupiter does not exist
	rm src/test/java/org/apache/commons/compress/compressors/deflate64/Deflate64CompressorInputStreamTest.java || die

	JAVA_TEST_EXTRA_ARGS=( -Djava.library.path=$(java-config -i zstd-jni) )
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi
}

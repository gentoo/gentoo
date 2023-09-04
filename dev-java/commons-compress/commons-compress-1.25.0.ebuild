# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Not ready for running tests, https://bugs.gentoo.org/839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-compress:1.24"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Java API for working with archive files"
# HOMEPAGE="https://commons.apache.org/proper/commons-compress/"
# SRC_URI="mirror://apache/commons/compress/source/${P}-src.tar.gz
# 	verify-sig? ( https://downloads.apache.org/commons/compress/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/asm:9
	dev-java/brotli-dec:0
	dev-java/xz-java:0
	dev-java/zstd-jni:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*
	dev-java/osgi-core:0"
#	test? (
#		dev-java/commons-io:1
#		dev-java/commons-lang:3.6
#		dev-java/felix-framework:0
#		dev-java/hamcrest:0
#		dev-java/javax-inject:0
#		dev-java/junit:5
#		dev-java/memoryfilesystem:0
#		dev-java/mockito:4
#		dev-java/mockito-junit-jupiter:4
#		dev-java/slf4j-api:0
#	)
#"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

# BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
# VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/commons.apache.org.asc"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.compress"
JAVA_CLASSPATH_EXTRA="osgi-core"
JAVA_ENCODING="iso-8859-1"
JAVA_MAIN_CLASS="org.apache.commons.compress.archivers.Lister"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	commons-io-1
	commons-lang-3.6
	felix-framework
	javax-inject
	junit-4
	junit-5
	hamcrest
	memoryfilesystem
	mockito-4
	mockito-junit-jupiter-4
	slf4j-api
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
#	default
	java-pkg-2_src_prepare
	# error: package org.ops4j.pax.exam does not exist
	# removing it costs 2 tests
	rm src/test/java/org/apache/commons/compress/OsgiITest.java || die

	# java.io.FileNotFoundException: couldn't find zstandard.testdata.zst
	# pom.xml lines 420-422
	tar xf src/test/resources/zstd-tests.tar \
		-C src/test/resources || die "cannot unpack zstd-tests.tar"

	# pom.xml lines 518-520
	tar xjf src/test/resources/zip64support.tar.bz2 \
		-C src/test/resources || die "cannot unpack zip64support.tar.bz2"

	JAVA_TEST_EXTRA_ARGS=( -Djava.library.path="${EPREFIX}/usr/$(get_libdir)/zstd-jni/" )
}

JAVA_TEST_EXCLUDES=(
	# No runnable methods
	org.apache.commons.compress.archivers.TestArchiveStreamProvider
	org.apache.commons.compress.compressors.TestCompressorStreamProvider

	# fails without useful message
	org.apache.commons.compress.compressors.DetectCompressorTestCase # has 8 tests

	# These tests pass but they prevent printing test messages::
#	org.apache.commons.compress.compressors.pack200.Pack200UtilsTest # has 2 tests
#	org.apache.commons.compress.compressors.FramedSnappyTestCase # has 5 tests
#	org.apache.commons.compress.compressors.XZTestCase # has 4 tests
#	org.apache.commons.compress.compressors.Pack200TestCase # has 15 tests
#	org.apache.commons.compress.harmony.pack200.tests.PackingOptionsTest # has 12 tests
#	org.apache.commons.compress.harmony.pack200.tests.ArchiveTest # has 9 tests
#	org.apache.commons.compress.harmony.unpack200.tests.ArchiveTest # has 13 tests
)

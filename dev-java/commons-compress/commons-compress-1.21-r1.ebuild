# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://apache.miloslavbrada.cz//commons/compress/source/commons-compress-1.21-src.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~x86" --ebuild commons-compress-1.21.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-compress:1.21"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API for working with archive files"
HOMEPAGE="https://commons.apache.org/proper/commons-compress/"
SRC_URI="mirror://apache/commons/compress/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Common dependencies
# POM: pom.xml
# asm:asm:3.2 -> !!!groupId-not-found!!!
# com.github.luben:zstd-jni:1.5.0-2 -> >=dev-java/zstd-jni-1.5.0.5:0
# org.brotli:dec:0.1.2 -> >=dev-java/brotli-dec-0.1.2:0
# org.tukaani:xz:1.9 -> >=dev-java/xz-java-1.9:0

CP_DEPEND="
	dev-java/asm:9
	dev-java/brotli-dec:0
	dev-java/xz-java:0
	dev-java/zstd-jni:0
"

# Compile dependencies
# POM: pom.xml
# org.osgi:osgi.core:6.0.0 -> >=dev-java/osgi-core-8.0.0:0
# POM: pom.xml
# test? com.github.marschall:memoryfilesystem:2.1.0 -> >=dev-java/memoryfilesystem-2.3.0:0
# test? javax.inject:javax.inject:1 -> >=dev-java/javax-inject-1:0
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# test? org.apache.felix:org.apache.felix.framework:7.0.0 -> >=dev-java/felix-framework-7.0.5:0
# test? org.hamcrest:hamcrest:2.2 -> >=dev-java/hamcrest-2.2:0
# test? org.mockito:mockito-core:3.11.1 -> >=dev-java/mockito-4.6.1:4
# test? org.ops4j.pax.exam:pax-exam-cm:4.13.1 -> !!!groupId-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-container-native:4.13.1 -> !!!groupId-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-junit4:4.13.1 -> !!!groupId-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-link-mvn:4.13.1 -> !!!groupId-not-found!!!
# test? org.slf4j:slf4j-api:1.7.30 -> >=dev-java/slf4j-api-1.7.36:0

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
	dev-java/osgi-core:0
	test? (
		dev-java/felix-framework:0
		dev-java/hamcrest:0
		dev-java/javax-inject:0
		dev-java/memoryfilesystem:0
		dev-java/mockito:4
		dev-java/slf4j-api:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}/${P}-asm7+.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.compress"
JAVA_CLASSPATH_EXTRA="osgi-core"
JAVA_ENCODING="iso-8859-1"
JAVA_MAIN_CLASS="org.apache.commons.compress.archivers.Lister"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="memoryfilesystem,javax-inject,junit-4,felix-framework,hamcrest,mockito-4,slf4j-api"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
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

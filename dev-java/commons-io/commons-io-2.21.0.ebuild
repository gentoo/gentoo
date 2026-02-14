# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Utility classes, stream implementations, file filters, and much more"
HOMEPAGE="https://commons.apache.org/proper/commons-io/"
SRC_URI="mirror://apache/commons/io/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/io/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

# [-vintage] because, if junit:5 compiled with 'USE=vintage':
# Error: Module junit not found, required by org.junit.vintage.engine
DEPEND="
	>=virtual/jdk-11:*
	test? (
		>=dev-java/asm-9.9:0
		>=dev-java/byte-buddy-1.17.8:0
		>=dev-java/commons-codec-1.20.0:0
		>=dev-java/commons-lang-3.19.0:0
		>=dev-java/jimfs-1.3.1:0
		>=dev-java/jmh-core-1.37:0
		>=dev-java/jna-5.18.1:0
		>=dev-java/jsr305-3.0.2-r1:0
		dev-java/junit:5[-vintage]
		>=dev-java/junit-pioneer-1.9.1-r1:0
		>=dev-java/mockito-5.20.0-r1:0
		>=dev-java/opentest4j-1.3.0-r1:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

PATCHES=(
	"${FILESDIR}/commons-io-2.20.0-BOMInputStreamTest.patch" # java.nio.BufferOverflowException
	"${FILESDIR}/commons-io-2.20.0-CharSequenceInputStreamTest.patch" # java.nio.BufferOverflowException
	"${FILESDIR}/commons-io-2.21.0-URIOriginalTest.patch" # java.net.UnknownHostException: example.com
	"${FILESDIR}/commons-io-2.20.0-XmlStreamReaderTest.patch" # Needs network access
)

JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm byte-buddy commons-codec commons-lang
	jimfs jmh-core jna jsr305 junit-pioneer junit-5 mockito opentest4j"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare

	# This test has compilation errors:
	# src/test/java/org/apache/commons/io/file/PathUtilsContentEqualsTest.java:125:
	# error: reference to newFileSystem is ambiguous
	#  FileSystem fileSystem2 = FileSystems.newFileSystem(refDir.resolveSibling(refDir.getFileName() + ".zip"), null)) {
	#                                      ^
	#   both method newFileSystem(Path,ClassLoader) in FileSystems and method newFileSystem(Path,Map<String,?>)
	#   in FileSystems match
	rm src/test/java/org/apache/commons/io/file/PathUtilsContentEqualsTest.java || die

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.{io,lang,util,time,time.chrono}=ALL-UNNAMED )
	fi
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A pure Java library for reading from and writing to MS Access databases"
HOMEPAGE="https://jackcess.sourceforge.io"
SRC_URI="https://github.com/jahlborn/jackcess/archive/${P}.tar.gz -> ${P}-sources.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="
	>=dev-java/poi-5.5.1:0
	>=dev-java/commons-lang-3.20.0:0
	>=dev-java/commons-logging-1.3.5-r1:0[log4j]
"

# src/main/java/com/healthmarketscience/jackcess/util/OleBlob.java:100:
# error: types Blob and Closeable are incompatible;
# public interface OleBlob extends Blob, Closeable
#        ^
#   interface OleBlob inherits abstract and default for close() from types Blob and Closeable
DEPEND="
	${CP_DEPEND}
	<virtual/jdk-26:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

PATCHES=( "${FILESDIR}/jackcess-4.0.0-fix-tests.patch" )

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXCLUDES=(
	# initializationError(com.healthmarketscience.jackcess.TestUtil)
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'com.healthmarketscience.jackcess.TestUtil'
	"com.healthmarketscience.jackcess.TestUtil"
)
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	export TZ=UTC
	export LC_ALL=C
	java-pkg-simple_src_test
}

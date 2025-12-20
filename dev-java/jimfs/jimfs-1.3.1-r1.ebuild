# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.jimfs:jimfs:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An in-memory file system for Java 7+"
HOMEPAGE="https://github.com/google/jimfs"
SRC_URI="https://github.com/google/jimfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/jimfs"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="
	dev-java/auto-service-annotations:0
	>=dev-java/error-prone-annotations-2.41.0:0
	>=dev-java/guava-33.4.8:0
	~dev-java/icu4j-77.1:0
	dev-java/jsr305:0
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/checker-framework-qual-3.49.5:0
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/guava-testlib-33.4.8:0
		dev-java/truth:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_AUTOMATIC_MODULE_NAME="com.google.common.jimfs"
JAVA_CLASSPATH_EXTRA="checker-framework-qual"
JAVA_RESOURCE_DIRS="src/main/res"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="guava-testlib junit-4 truth"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p src/main/res/META-INF/services || die
	echo "com.google.common.jimfs.SystemJimfsFileSystemProvider" > \
		src/main/res/META-INF/services/java.nio.file.spi.FileSystemProvider || die
}

src_test() {
	# Using the defaults of java-pkg-simple would exclude
	# several tests which are run by "mvn test".
	local JAVA_TEST_RUN_ONLY=$(find src/test/java \
		-name "*Test.java" \
		! -name AbstractGlob*.java \
		! -name AbstractPathMatcherTest.java \
		! -name AbstractJimfsIntegrationTest.java \
		! -name AbstractAttributeProviderTest.java \
		-printf '%P\n')
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

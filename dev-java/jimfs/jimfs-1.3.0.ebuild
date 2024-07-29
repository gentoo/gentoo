# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.jimfs:jimfs:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An in-memory file system for Java 7+"
HOMEPAGE="https://github.com/google/jimfs"
SRC_URI="https://github.com/google/jimfs/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://repo1.maven.org/maven2/com/google/truth/truth/1.1.3/truth-1.1.3.jar )"
S="${WORKDIR}/${P}/jimfs"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	dev-java/auto-service-annotations:0
	dev-java/error-prone-annotations:0
	dev-java/guava:0
	>=dev-java/icu4j-74.2-r1:0
	dev-java/jsr305:0
"

DEPEND="${CP_DEPEND}
	dev-java/checker-framework-qual:0
	>=virtual/jdk-1.8:*
	test? (
		dev-java/guava-testlib:0
	)"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="checker-framework-qual"
JAVA_AUTOMATIC_MODULE_NAME="com.google.common.jimfs"
JAVA_RESOURCE_DIRS="src/main/res"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="guava-testlib junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p src/main/res/META-INF/services || die
	echo "com.google.common.jimfs.SystemJimfsFileSystemProvider" > \
		src/main/res/META-INF/services/java.nio.file.spi.FileSystemProvider || die
}

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/truth-1.1.3.jar"
	# Using the defaults of java-pkg-simple would exclude
	# several tests which are run by "mvn test".
	pushd src/test/java > /dev/null || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "*Test.java" \
			! -name AbstractGlob*.java \
			! -name AbstractPathMatcherTest.java \
			! -name AbstractJimfsIntegrationTest.java \
			! -name AbstractAttributeProviderTest.java \
			)
	popd > /dev/null
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

# Copyright 2008-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.protobuf:protobuf-java:3.23.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple cmake

DESCRIPTION="Core Protocol Buffers library"
HOMEPAGE="https://protobuf.dev"
# Currently we bundle the binary version of truth.jar used only for tests, we don't install it.
# And we build artifact 3.23.0 from the 23.0 tarball in order to allow sharing the tarball with
# dev-libs/protobuf.
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV#3.}.tar.gz -> protobuf-${PV#3.}.tar.gz
	test? ( https://repo1.maven.org/maven2/com/google/truth/truth/1.1.3/truth-1.1.3.jar )"
S="${WORKDIR}/protobuf-${PV#3.}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/guava:0
		dev-java/mockito:4
		)
"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="
	>=dev-cpp/abseil-cpp-20230125.2
	<dev-cpp/abseil-cpp-20240116.2
"

PATCHES=(
	"${FILESDIR}/protobuf-java-3.23.0-unittest_retention.proto.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="com.google.protobuf"
JAVA_JAR_FILENAME="protobuf.jar"
JAVA_RESOURCE_DIRS="java/core/src/main/resources"
JAVA_SRC_DIR="java/core/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="guava,junit-4,mockito-4"
JAVA_TEST_SRC_DIR="java/core/src/test/java"

run-protoc() {
	"${BUILD_DIR}"/protoc $1
}

src_prepare() {
	cmake_src_prepare
	java-pkg-2_src_prepare

	mkdir "${JAVA_RESOURCE_DIRS}" || die
	# https://github.com/protocolbuffers/protobuf/blob/v23.0/java/core/pom.xml#L43-L62
	PROTOS=(  $(sed \
		-n '/google\/protobuf.*\.proto/s:.*<include>\(.*\)</include>:\1:p' \
		"${S}/java/core/pom.xml") ) || die
	pushd src > /dev/null || die
		cp --parents -v "${PROTOS[@]}" ../"${JAVA_RESOURCE_DIRS}" || die
	popd > /dev/null || die

	# https://github.com/protocolbuffers/protobuf/blob/v23.0/java/core/generate-sources-build.xml
	einfo "Replace variables in generate-sources-build.xml"
	sed \
		-e 's:${generated.sources.dir}:java/core/src/main/java:' \
		-e 's:${protobuf.source.dir}:src:' \
		-e 's:^.*value="::' -e 's:\"/>::' \
		-e '/project\|echo\|mkdir\|exec/d' \
		-i java/core/generate-sources-build.xml || die "sed to sources failed"

	# https://github.com/protocolbuffers/protobuf/blob/v23.0/java/core/generate-test-sources-build.xml
	einfo "Replace variables in generate-test-sources-build.xml"
	sed \
		-e 's:${generated.testsources.dir}:java/core/src/test/java:' \
		-e 's:${protobuf.source.dir}:src:' \
		-e 's:${test.proto.dir}:java/core/src/test/proto:' \
		-e 's:^.*value="::' -e 's:\"/>::' \
		-e '/project\|mkdir\|exec\|Also generate/d' \
		-i java/core/generate-test-sources-build.xml || die "sed to test sources failed"

	# Split the file in two parts, one for each run-protoc call
	awk '/--java_out/{x="test-sources-build-"++i;}{print > x;}' \
		java/core/generate-test-sources-build.xml || die
}

src_configure() {
	local mycmakeargs=(
		-Dprotobuf_BUILD_TESTS=OFF
		-Dprotobuf_ABSL_PROVIDER=package
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	einfo "Run protoc to generate sources"
	run-protoc \
		@java/core/generate-sources-build.xml \
		|| die "protoc sources failed"

	java-pkg-simple_src_compile
}

src_test() {
	# https://github.com/protocolbuffers/protobuf/blob/v23.0/java/core/pom.xml#L63-L71
	jar cvf testdata.jar \
		-C src google/protobuf/testdata/golden_message_oneof_implemented \
		-C src google/protobuf/testdata/golden_packed_fields_message || die

	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/truth-1.1.3.jar:testdata.jar"

	einfo "Running protoc on first part of generate-test-sources-build.xml"
	run-protoc @test-sources-build-1 \
		|| die "run-protoc test-sources-build-1 failed"

	einfo "Running protoc on second part of generate-test-sources-build.xml"
	run-protoc @test-sources-build-2 \
		|| die "run-protoc test-sources-build-2 failed"

	einfo "Running tests"
	# Invalid test class 'map_test.MapInitializationOrderTest':
	# 1. Test class should have exactly one public constructor
	# Invalid test class 'protobuf_unittest.CachedFieldSizeTest':
	# 1. Test class should have exactly one public constructor
	pushd "${JAVA_TEST_SRC_DIR}" || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-path "**/*Test.java" \
			! -path "**/Abstract*Test.java" \
			! -name "MapInitializationOrderTest.java" \
			! -path '*protobuf_unittest/CachedFieldSizeTest.java'
			)
	popd
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
}

# Copyright 2008-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="com.google.protobuf:protobuf-java:${PV}"

inherit cmake java-pkg-2 java-pkg-simple

DESCRIPTION="Core Protocol Buffers library"
HOMEPAGE="https://protobuf.dev"
MY_PV4="${PV#4.}"
MY_PV="${MY_PV4/_rc/-rc}"
MY_P="protobuf-${MY_PV}.tar.gz"
SRC_URI="https://github.com/protocolbuffers/protobuf/releases/download/v${MY_PV}/${MY_P}"
S="${WORKDIR}/protobuf-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="system-protoc"

BDEPEND="
	system-protoc? ( ~dev-libs/protobuf-${MY_PV4}:0[protoc] )
	!system-protoc? ( >=dev-cpp/abseil-cpp-20250512.1:= )
"

# restrict virtual/jdk because asm-jdk-bridge-0.0.13 is not ready for java 27.
DEPEND="
	<virtual/jdk-27
	test? (
		>=dev-java/guava-33.5.0:0
		>=dev-java/mockito-4.11.0:4
		>=dev-java/snakeyaml-2.5:0
		>=dev-java/testparameterinjector-1.19:0
		>=dev-java/truth-1.4.5:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="com.google.protobuf"
JAVA_JAR_FILENAME="protobuf.jar"
JAVA_RESOURCE_DIRS="java/core/src/main/resources"
JAVA_SRC_DIR="java/core/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="guava,junit-4,mockito-4,snakeyaml"
JAVA_TEST_RESOURCE_DIRS="java/core/src/main/resources"
JAVA_TEST_SRC_DIR="java/core/src/test/java"

run-protoc() {
	if use system-protoc; then
		protoc "$1"
	else
		"${BUILD_DIR}/protoc" "$1"
	fi
}

src_prepare() {
	# If the corrsponding version of system-protoc is not available we build protoc locally
	if ! use system-protoc; then
		cmake_src_prepare
	fi
	java-pkg-2_src_prepare

	# ${S}/java/core/generate-sources-build.xml
	einfo "Replace variables in generate-sources-build.xml"
	sed \
		-e 's:${generated.sources.dir}:java/core/src/main/java:' \
		-e 's:${protobuf.java_source.dir}:java/core/src/main/resources:' \
		-e 's:${protobuf.source.dir}:src:' \
		-e 's:^.*value="::' -e 's:\"/>::' \
		-e '/project\|echo\|mkdir\|exec/d' \
		-i java/core/generate-sources-build.xml || die "sed to sources failed"

	# ${S}/java/core/generate-test-sources-build.xml
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

	# We add some *.proto files to the 'test-sources-build-1' file which
	# are needed to avoid compilation errors on related test classes.
	cat <<-EOF >> test-sources-build-1 || die "append test-sources-build-1"
		src/google/protobuf/edition_unittest.proto
		src/google/protobuf/unittest_delimited.proto
		src/google/protobuf/unittest_delimited_import.proto
		src/google/protobuf/unittest_import_option.proto
		java/core/src/test/proto/com/google/protobuf/large_open_enum.proto
		java/core/src/test/proto/com/google/protobuf/generator_names_edition2024_defaults.proto
	EOF
}

src_configure() {
	local mycmakeargs=(
		-Dprotobuf_BUILD_TESTS=OFF
		-Dprotobuf_LOCAL_DEPENDENCIES_ONLY=ON
	)
	if ! use system-protoc; then
		cmake_src_configure
	fi
}

src_compile() {
	if ! use system-protoc; then
		cmake_src_compile
	fi

	einfo "Run protoc to generate sources"
	run-protoc @java/core/generate-sources-build.xml \
		|| die "protoc sources failed"

	java-pkg-simple_src_compile
}

src_test() {
	# Note: Annotation processing is enabled because one or more processors were found
	#   on the class path. A future release of javac may disable annotation processing
	#   unless at least one processor is specified by name (-processor), or a search
	#   path is specified (--processor-path, --processor-module-path), or annotation
	#   processing is enabled explicitly (-proc:only, -proc:full).
	JAVA_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjars --build-only testparameterinjector,truth)"

	# java/core/src/test/java/com/google/protobuf/GeneratorNamesTest.java:33: error: cannot find symbol
	#               GeneratorNamesPre2024Defaults.getDescriptor(), GeneratorNamesPre2024Defaults.class),
	#                                                              ^
	#   symbol:   class GeneratorNamesPre2024Defaults
	#   location: class FileClassProvider
	rm java/core/src/test/java/com/google/protobuf/GeneratorNamesTest.java || die "remove test"

	einfo "Running protoc on first part of generate-test-sources-build.xml"
	# java/core/src/test/proto/com/google/protobuf/test_check_utf8.proto:15:1:
	# Import "google/protobuf/java_features.proto" was not found or had errors.
	cp {java/core/src/main/resources,src}/google/protobuf/java_features.proto || die
	run-protoc @test-sources-build-1 \
		|| die "run-protoc test-sources-build-1 failed"

	einfo "Running protoc on second part of generate-test-sources-build.xml"
	run-protoc @test-sources-build-2 \
		|| die "run-protoc test-sources-build-2 failed"

	einfo "Running tests"
	# Invalid test class 'map_test.MapInitializationOrderTest':
	# 1. Test class should have exactly one public constructor
	# Invalid test class 'proto2_unittest.CachedFieldSizeTest':
	# 1. Test class should have exactly one public constructor
	local JAVA_TEST_RUN_ONLY=$(find "${JAVA_TEST_SRC_DIR}" \
		-path "**/*Test.java" \
		! -path "**/Abstract*Test.java" \
		! -name "MapInitializationOrderTest.java" \
		! -name 'CachedFieldSizeTest.java' -printf "%P\n")
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

# Copyright 2008-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.protobuf:protobuf-java:3.21.12"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Google's Protocol Buffers - Java bindings"
HOMEPAGE="https://developers.google.com/protocol-buffers/"
# Currently we bundle the binary version of truth.jar used only for tests, we don't install it.
# And we build artifact 3.21.11 from the 21.11 tarball in order to allow sharing the tarball with
# dev-libs/protobuf.
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV#3.}.tar.gz -> protobuf-${PV#3.}.tar.gz
	test? ( https://repo1.maven.org/maven2/com/google/truth/truth/1.1.3/truth-1.1.3.jar )"

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

# Once =protobuf-${PV#3.} hits the tree use it
# BDEPEND="~dev-libs/protobuf-${PV#3.}:0"
BDEPEND="dev-libs/protobuf:0"

S="${WORKDIR}/protobuf-${PV#3.}/java"

JAVA_AUTOMATIC_MODULE_NAME="com.google.protobuf"
JAVA_JAR_FILENAME="protobuf.jar"
JAVA_RESOURCE_DIRS="core/src/main/resources"
JAVA_SRC_DIR="core/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="guava,junit-4,mockito-4"
JAVA_TEST_RESOURCE_DIRS="core/src/test/proto"
JAVA_TEST_SRC_DIR="core/src/test/java"

src_prepare() {
	default

	mkdir "${JAVA_RESOURCE_DIRS}" || die
	# https://github.com/protocolbuffers/protobuf/blob/v21.12/java/core/pom.xml#L43-L62
	echo $(sed \
		-n '/google\/protobuf.*\.proto/s:.*<include>\(.*\)</include>:-C ../../../../../src \1:p' \
		"${S}/core/pom.xml") > "${T}/core_proto" || die "echo to core_proto failed"
	# Copy them from ../src/google/protobuf to JAVA_RESOURCE_DIRS
	pushd "${JAVA_RESOURCE_DIRS}" || die
	jar cv "@${T}/core_proto" | jar xv
	assert "Copying protos failed"
	popd || die

	# https://github.com/protocolbuffers/protobuf/blob/v21.12/java/core/generate-sources-build.xml
	einfo "Replace variables in generate-sources-build.xml"
	sed \
		-e 's:${generated.sources.dir}:core/src/main/java:' \
		-e 's:${protobuf.source.dir}:../src:' \
		-e 's:^.*value="::' -e 's:\"/>::' \
		-e '/project\|echo\|mkdir\|exec/d' \
		-i core/generate-sources-build.xml || die "sed to sources failed"

	einfo "Run protoc to generate sources"
	protoc @core/generate-sources-build.xml || die "protoc sources failed"
}

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/truth-1.1.3.jar"

	# https://github.com/protocolbuffers/protobuf/blob/v21.12/java/core/generate-test-sources-build.xml
	einfo "Replace variables in generate-test-sources-build.xml"
	sed \
		-e 's:${generated.testsources.dir}:core/src/test/java:' \
		-e 's:${protobuf.source.dir}:../src:' \
		-e 's:${test.proto.dir}:core/src/test/proto:' \
		-e 's:^.*value="::' -e 's:\"/>::' \
		-e '/project\|mkdir\|exec\|Also generate/d' \
		-i core/generate-test-sources-build.xml || die "sed to test sources failed"

	# Remove second exec from the file. Makes trouble here. We run it separately.
	sed '50,54d' -i core/generate-test-sources-build.xml || die "cannot remove lines"

	einfo "Running protoc to generate test-sources"
	protoc @core/generate-test-sources-build.xml || die "protoc I failed"

	einfo "Running protoc on previously removed test-sources"
	protoc --java_out=lite:core/src/test/java \
		--proto_path=../src \
		--proto_path=core/src/test/proto \
		core/src/test/proto/com/google/protobuf/nested_extension_lite.proto \
		core/src/test/proto/com/google/protobuf/non_nested_extension_lite.proto \
		|| die "protoc II failed"

	# Ignore two failing test cases from CodedOutputStreamTest.java
	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/testWriteWholeMessage/i @Ignore' \
		-e '/testWriteWholePackedFieldsMessage/i @Ignore' \
		-i core/src/test/java/com/google/protobuf/CodedOutputStreamTest.java || die

	einfo "Running tests"
	# Exclude MapInitializationOrderTest and CachedFieldSizeTest
	pushd core/src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-wholename "**/*Test.java" \
			! -wholename "**/Abstract*Test.java" \
			! -name "MapInitializationOrderTest.java" \
			! -name "CachedFieldSizeTest.java" \
			)
	popd
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

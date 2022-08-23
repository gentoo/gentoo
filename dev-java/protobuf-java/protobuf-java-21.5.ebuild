# Copyright 2008-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Tests not enabled, depend on google truth which is not packaged
# https://github.com/protocolbuffers/protobuf/blob/v21.4/java/core/pom.xml#L35-L40
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.protobuf:protobuf-java:3.21.5"

inherit java-pkg-2 java-pkg-simple

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="Google's Protocol Buffers - Java bindings"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> protobuf-${PV}.tar.gz"
fi

LICENSE="BSD"
SLOT="0/30"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

BDEPEND="dev-libs/protobuf:${SLOT}"

S="${WORKDIR}/protobuf-${PV}/java"

if [[ "${PV}" == "9999" ]]; then
	EGIT_CHECKOUT_DIR="${WORKDIR}/protobuf-${PV}"
fi

JAVA_SRC_DIR="core/src/main/java"
JAVA_RESOURCE_DIRS="core/src/main/resources"
JAVA_AUTOMATIC_MODULE_NAME="com.google.protobuf"
JAVA_JAR_FILENAME="protobuf.jar"

src_prepare() {
	default
	java-pkg-2_src_prepare
	# Copy resources from ../src/google/protobuf according to
	# https://github.com/protocolbuffers/protobuf/blob/v3.21.2/java/core/pom.xml#L45-L61
	mkdir -p core/src/main/resources/google/protobuf/compiler || die
	cp {../src,core/src/main/resources}/google/protobuf/compiler/plugin.proto || die
	cp ../src/google/protobuf/{any,api,descriptor,duration,empty,field_mask,source_context,struct,timestamp,type,wrappers}.proto \
		"${JAVA_RESOURCE_DIRS}/google/protobuf" || die

	# Generate 146 .java files according to
	# https://github.com/protocolbuffers/protobuf/blob/v3.21.1/java/core/generate-sources-build.xml
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/any.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/api.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/compiler/plugin.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/descriptor.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/duration.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/empty.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/field_mask.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/source_context.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/struct.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/timestamp.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/type.proto || die
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/wrappers.proto || die
}

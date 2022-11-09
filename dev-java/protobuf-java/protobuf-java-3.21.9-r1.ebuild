# Copyright 2008-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.protobuf:protobuf-java:3.21.9"
# Tests not enabled, depend on com.google.truth which is not packaged
# https://github.com/protocolbuffers/protobuf/blob/v21.9/java/core/pom.xml#L35-L40
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit edo java-pkg-2 java-pkg-simple

PARENT_PN="${PN/-java/}"
PARENT_PV="$(ver_cut 2-)"
PARENT_P="${PARENT_PN}-${PARENT_PV}"
PARENT_SUBSLOT="32"

DESCRIPTION="Google's Protocol Buffers - Java bindings"
HOMEPAGE="https://developers.google.com/protocol-buffers/"
SRC_URI="
	https://github.com/protocolbuffers/protobuf/archive/v${PARENT_PV}.tar.gz
		-> ${PARENT_P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/guava:0
		dev-java/mockito:4
	)
"
RDEPEND=">=virtual/jre-1.8:*"

BDEPEND="dev-libs/protobuf:0/${PARENT_SUBSLOT}"

S="${WORKDIR}/${PARENT_P}/java"

JAVA_AUTOMATIC_MODULE_NAME="com.google.protobuf"
JAVA_JAR_FILENAME="protobuf.jar"
JAVA_RESOURCE_DIRS="core/src/main/resources"
JAVA_SRC_DIR="core/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="guava,junit-4,mockito-4"
JAVA_TEST_RESOURCE_DIRS="../src"
JAVA_TEST_SRC_DIR="core/src/test/java"

# Same than PATCHES but from repository's root directory,
# please see function `src_prepare` below.
# Simplier for users IMHO.
PARENT_PATCHES=(
)

# Here for patches within "java/" subdirectory.
PATCHES=(
)

src_prepare() {
	pushd "${WORKDIR}/${PARENT_P}" > /dev/null || die
	[[ -n "${PARENT_PATCHES[@]}" ]] && eapply "${PARENT_PATCHES[@]}"
	eapply_user
	popd > /dev/null || die

	# Same than default without the eapply_user part, this last is kept
	# for the parent directory.
	# It looks like function java-pkg-2_src_prepare doesn’t call "default".
	[[ -n "${PATCHES[@]}" ]] && eapply "${PATCHES[@]}"

	# Remove bundled jars
	java-pkg_clean

	java-pkg-2_src_prepare

	# There is also compiler/plugin, but not in this list because in a subdirectory
	core_protos=( any api descriptor duration empty field_mask source_context struct timestamp type wrappers )

	# Copy resources from ../src/google/protobuf according to
	# https://github.com/protocolbuffers/protobuf/blob/v21.9/java/core/pom.xml#L45-L61
	mkdir -p "${JAVA_RESOURCE_DIRS}/google/protobuf/compiler" || die
	local core_proto
	for core_proto in "${core_protos[@]}"; do
		cp "../src/google/protobuf/${core_proto}.proto" \
		   "${JAVA_RESOURCE_DIRS}/google/protobuf" \
			|| die
	done
	cp {../src,"${JAVA_RESOURCE_DIRS}"}/google/protobuf/compiler/plugin.proto || die

	# Generate 146 .java files according to
	# https://github.com/protocolbuffers/protobuf/blob/v21.9/java/core/generate-sources-build.xml
	for core_proto in "${core_protos[@]}" compiler/plugin; do
		edo "${BROOT}/usr/bin/protoc" \
			--java_out="${JAVA_SRC_DIR}" -I../src ../src/google/protobuf/"${core_proto}".proto
	done
}

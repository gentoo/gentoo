# Copyright 2008-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_CHECKOUT_DIR="${WORKDIR}/protobuf-${PV}"
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
S="${WORKDIR}/protobuf-${PV}/java"

LICENSE="BSD"
SLOT="0/31"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

COMMON_DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="
	~dev-libs/protobuf-${PV}
	${COMMON_DEPEND}
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${DEPEND}"

src_prepare() {
	pushd "${WORKDIR}/protobuf-${PV}" > /dev/null || die
	eapply_user
	popd > /dev/null || die

	java-pkg-2_src_prepare
}

src_compile() {
	"${BROOT}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/descriptor.proto || die
	JAVA_SRC_DIR="core/src/main/java" JAVA_JAR_FILENAME="protobuf.jar" java-pkg-simple_src_compile
}

src_install() {
	JAVA_SRC_DIR="core/src/main/java" JAVA_JAR_FILENAME="protobuf.jar" java-pkg-simple_src_install
}

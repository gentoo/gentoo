# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Google's Protocol Buffers - Java bindings"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/google/protobuf"
SRC_URI="https://github.com/google/protobuf/archive/v${PV}.tar.gz -> protobuf-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/16"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sh ~x86 ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

DEPEND="~dev-libs/protobuf-${PV}
	>=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7
	!<dev-libs/protobuf-3[java(-)]"

S="${WORKDIR}/protobuf-${PV}/java"

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_compile() {
	"${EPREFIX}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/descriptor.proto || die
	JAVA_SRC_DIR="core/src/main/java" JAVA_JAR_FILENAME="protobuf.jar" java-pkg-simple_src_compile
}

src_install() {
	JAVA_SRC_DIR="core/src/main/java" JAVA_JAR_FILENAME="protobuf.jar" java-pkg-simple_src_install
}

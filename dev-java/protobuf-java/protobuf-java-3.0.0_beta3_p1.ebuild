# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-pkg-simple

MY_PV=${PV/_beta/-beta-}
MY_PV=${MY_PV/_p/.}

DESCRIPTION="Google's Protocol Buffers - official Java Bindings"
HOMEPAGE="https://github.com/google/protobuf/ https://developers.google.com/protocol-buffers/"
SRC_URI="https://github.com/google/protobuf/archive/v${MY_PV}.tar.gz -> protobuf-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/10b3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sh ~x86 ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="nano"

# Protobuf is only a build-time dep, but depend on the exact same version
# (excluding revision), since we are using the same tarball.
# But probably same subslot is sufficient.
DEPEND=">=virtual/jdk-1.7
	>=dev-libs/protobuf-3"
RDEPEND=">=virtual/jre-1.7
	!<dev-libs/protobuf-3[java(-)]"
S="${WORKDIR}/protobuf-${MY_PV}"

src_prepare() {
	epatch_user
	java-pkg-2_src_prepare
}

src_compile() {
	pushd "${S}/java" >/dev/null || die
	einfo "Compiling Java library ..."
	/usr/bin/protoc --java_out=core/src/main/java -I../src ../src/google/protobuf/descriptor.proto || die
	JAVA_SRC_DIR="${S}/java/core/src/main/java"
	JAVA_JAR_FILENAME="protobuf.jar"
	java-pkg-simple_src_compile
	popd >/dev/null || die
	if use nano; then
		einfo "Compiling Java Nano library ..."
		pushd "${S}/javanano" >/dev/null || die
		/usr/bin/protoc --java_out=src/main/java -I../src ../src/google/protobuf/descriptor.proto || die
		JAVA_SRC_DIR="${S}/javanano/src/main/java"
		JAVA_GENTOO_CLASSPATH_EXTRA="${S}/java/core/src/main/java/"
		JAVA_JAR_FILENAME="protobuf-nano.jar"
		java-pkg-simple_src_compile
		popd >/dev/null || die
	fi
}

src_install() {
	JAVA_JAR_FILENAME="${S}/java/protobuf.jar"
	JAVA_SRC_DIR="${S}/java/core/src/main/java"
	if use nano; then
		JAVA_JAR_FILENAME="${JAVA_JAR_FILENAME} ${S}/javanano/protobuf-nano.jar"
		JAVA_SRC_DIR="${JAVA_SRC_DIR} ${S}/javanano/src/main/java"
	fi
	mv "${S}/java/target" . || die
	if use nano; then
		cp -Rvf "${S}/javanano/target" . || die
	fi
	java-pkg-simple_src_install
}

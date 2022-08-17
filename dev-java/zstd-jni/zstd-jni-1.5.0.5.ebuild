# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAVEN_ID="com.github.luben:zstd-jni:1.5.0-5"
MY_PV="$(ver_rs 3 -)"

inherit java-pkg-2 java-pkg-simple cmake

DESCRIPTION="JNI bindings for Zstd native library"

HOMEPAGE="https://github.com/luben/zstd-jni"
SRC_URI="https://github.com/luben/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

PATCHES=(
	"${FILESDIR}/zstd-jni-1.5.0.4-filter-flags.patch"
)

JAVA_SRC_DIR="src/main/java"

src_prepare() {
	cmake_src_prepare

	echo -e "package com.github.luben.zstd.util;\n\npublic class ZstdVersion\n{\n\tpublic static final String VERSION = \"${PV}\";\n}\n" \
		>> ${JAVA_SRC_DIR}/com/github/luben/zstd/util/ZstdVersion.java || die "Failed to generate version class"
}

src_configure() {
	local mycmakeargs=(
		-DJAVA_HOME="$(java-config -g JAVA_HOME)"
		# Resolve bug #776910
		# Reference: https://stackoverflow.com/a/51764145
		-DJAVA_AWT_LIBRARY="NotNeeded"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	mkdir -p "${S}/target/classes/META-INF" || die "Failed to create META-INF dir"
	echo "Manifest-Version: 1.0
Implementation-Version: ${MY_PV}
Bundle-NativeCode: libzstd-jni.so;osname=Linux" > "${S}/target/classes/META-INF/MANIFEST.MF" || die "Failed to create MANIFEST.MF"
	java-pkg-simple_src_compile
	java-pkg_addres ${JAVA_JAR_FILENAME} "${BUILD_DIR}" -name libzstd-jni.so || die "Failed to add library to jar"
}

src_install() {
	java-pkg-simple_src_install
}

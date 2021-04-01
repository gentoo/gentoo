# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MAVEN_ID="com.github.luben:zstd-jni:1.4.9-1"
MY_PV="$(ver_rs 3 -)"

inherit java-pkg-2 java-pkg-simple cmake

DESCRIPTION="JNI bindings for Zstd native library"

HOMEPAGE="https://github.com/luben/zstd-jni"
SRC_URI="https://github.com/luben/${PN}/archive/v${MY_PV}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND="${RDEPEND}"

JAVA_SRC_DIR="src/main/java"

src_configure() {
	local mycmakeargs=(
		-DJAVA_HOME="$(java-config -g JAVA_HOME)"
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

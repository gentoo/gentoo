# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.luben:zstd-jni:1.5.2-3"

inherit java-pkg-2 java-pkg-simple cmake

DESCRIPTION="JNI bindings for Zstd native library"
HOMEPAGE="https://github.com/luben/zstd-jni"
SRC_URI="https://github.com/luben/zstd-jni/archive/v$(ver_rs 3 -).tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

S="${WORKDIR}/zstd-jni-$(ver_rs 3 -)"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="resources"
JAVA_AUTOMATIC_MODULE_NAME="com.github.luben.zstd_jni"

src_prepare() {
	cmake_src_prepare
	# https://github.com/luben/zstd-jni/blob/v1.5.2-3/build.gradle#L66
	cat > src/main/java/com/github/luben/zstd/util/ZstdVersion.java <<-EOF || die
		package com.github.luben.zstd.util;

		public class ZstdVersion
		{
			public static final String VERSION = "${PV}";
		}
	EOF

	mkdir -p  resources/META-INF || die
	cat > resources/META-INF/MANIFEST.MF <<-EOF || die
		Implementation-Version: $(ver_rs 3 -)
		Bundle-NativeCode: libzstd-jni.so;osname=Linux"
	EOF
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
	java-pkg-simple_src_compile
	java-pkg_addres zstd-jni.jar "${BUILD_DIR}" -name "libzstd-jni-$(ver_rs 3 -).so"
}

src_install() {
	java-pkg-simple_src_install
}

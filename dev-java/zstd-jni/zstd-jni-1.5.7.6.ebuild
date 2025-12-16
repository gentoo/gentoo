# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit cmake java-pkg-2 java-pkg-simple

DESCRIPTION="JNI bindings for Zstd native library"
HOMEPAGE="https://github.com/luben/zstd-jni"
SRC_URI="https://github.com/luben/zstd-jni/archive/v$(ver_rs 3 -).tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/zstd-jni-$(ver_rs 3 -)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

PATCHES=( "${FILESDIR}/zstd-jni-1.5.7.6-cmake_minimum_required.patch" )

JAVA_AUTOMATIC_MODULE_NAME="com.github.luben.zstd_jni"
JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	cmake_src_prepare
	# https://github.com/luben/zstd-jni/blob/c1.5.2-5/build.gradle#L66
	cat > src/main/java/com/github/luben/zstd/util/ZstdVersion.java <<-EOF || die
		package com.github.luben.zstd.util;

		public class ZstdVersion
		{
			public static final String VERSION = "$(ver_rs 3 -)";
		}
	EOF

	mkdir -p  resources/META-INF || die
	echo "Implementation-Version: $(ver_rs 3 -)" \
		> resources/META-INF/MANIFEST.MF || die
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
}

src_install() {
	java-pkg_doso "${BUILD_DIR}/libzstd-jni-$(ver_rs 3 -).so"
	java-pkg-simple_src_install
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="waifu2x converter using ncnn and vulkan"
HOMEPAGE="https://github.com/nihui/waifu2x-ncnn-vulkan"

SRC_URI="https://github.com/nihui/waifu2x-ncnn-vulkan/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	~dev-libs/ncnn-20200727
	media-libs/vulkan-loader
	media-libs/libwebp
	dev-util/glslang"

RDEPEND="${DEPEND}"
BDEPEND=""

CMAKE_USE_DIR="${S}/src"

src_prepare() {
	# Make finding models actually possible.
	sed -i 's|path_t model = PATHSTR("models-cunet")|path_t model = PATHSTR("/usr/share/waifu2x-ncnn-vulkan/models-cunet")|' src/main.cpp

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DUSE_SYSTEM_NCNN=ON"
		"-DUSE_SYSTEM_WEBP=ON"
		"-DGLSLANG_TARGET_DIR=${EPREFIX}/usr/$(get_libdir)/cmake"
	)

	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/waifu2x-ncnn-vulkan

	insinto "/usr/share/${PN}"
	doins -r models/*
}

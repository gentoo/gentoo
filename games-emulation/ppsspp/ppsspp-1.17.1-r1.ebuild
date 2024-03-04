# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit flag-o-matic python-any-r1 xdg cmake

DESCRIPTION="A PSP emulator written in C++"
HOMEPAGE="https://www.ppsspp.org/
	https://github.com/hrydgard/ppsspp/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/hrydgard/${PN}.git"
else
	SRC_URI="https://github.com/hrydgard/${PN}/releases/download/v${PV}/${P}.tar.xz"

	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 JSON MIT"
SLOT="0"
IUSE="discord qt5 test wayland"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/snappy:=
	app-arch/zstd:=
	dev-libs/libzip:=
	media-libs/glew:=
	media-libs/libpng:=
	media-libs/libsdl2[joystick]
	media-video/ffmpeg:0/58.60.60
	sys-libs/zlib:=
	virtual/opengl
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qtmultimedia:5[-gles2-only]
		dev-qt/qtopengl:5[-gles2-only]
		dev-qt/qtwidgets:5[-gles2-only]
	)
	!qt5? (
		media-libs/libsdl2[X,opengl,sound,video,wayland?]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}/${PN}-1.17.1-avcodec-18825.patch"
	"${FILESDIR}/${PN}-1.17.1-ccache-18826.patch"
	"${FILESDIR}/${PN}-1.17.1-cmake-cxx.patch"
	"${FILESDIR}/${PN}-CMakeLists-flags.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	# bug https://bugs.gentoo.org/926079
	filter-lto

	local -a mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DHEADLESS=OFF
		-DUSE_CCACHE=OFF
		-DUSE_SYSTEM_FFMPEG=ON
		-DUSE_SYSTEM_LIBZIP=ON
		-DUSE_SYSTEM_SNAPPY=ON
		-DUSE_SYSTEM_ZSTD=ON
		-DUSE_DISCORD=$(usex discord)
		-DUSE_WAYLAND_WSI=$(usex wayland)
		-DUSING_QT_UI=$(usex qt5)
		-DUNITTEST=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	cmake_src_test -E glslang-testsuite
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit python-any-r1 xdg cmake

DESCRIPTION="A PSP emulator written in C++"
HOMEPAGE="https://www.ppsspp.org/
	https://github.com/hrydgard/ppsspp/"
SRC_URI="https://github.com/hrydgard/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 JSON MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="discord qt5"
RESTRICT="test"

RDEPEND="
	app-arch/snappy:=
	app-arch/zstd:=
	dev-libs/libzip:=
	media-libs/glew:=
	media-libs/libpng:=
	media-libs/libsdl2[joystick]
	media-video/ffmpeg:0/56.58.58
	sys-libs/zlib:=
	virtual/opengl
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qtmultimedia:5[-gles2-only]
		dev-qt/qtopengl:5[-gles2-only]
		dev-qt/qtwidgets:5[-gles2-only]
	)
	!qt5? ( media-libs/libsdl2[X,opengl,sound,video] )
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-CMakeLists-flags.patch
	"${FILESDIR}"/${PN}-disable-ccache-autodetection.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local -a mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DHEADLESS=false
		-DUSE_SYSTEM_FFMPEG=ON
		-DUSE_SYSTEM_LIBZIP=ON
		-DUSE_SYSTEM_SNAPPY=ON
		-DUSE_SYSTEM_ZSTD=ON
		-DUSE_DISCORD=$(usex discord)
		-DUSING_QT_UI=$(usex qt5)
	)
	cmake_src_configure
}

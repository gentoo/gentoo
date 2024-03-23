# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Nintendo Entertainment System (NES) emulator"
HOMEPAGE="https://github.com/punesemu/puNES"
SRC_URI="https://github.com/punesemu/puNES/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/puNES-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X cg ffmpeg qt6"

RDEPEND="
	media-libs/alsa-lib
	media-libs/libglvnd[X?]
	virtual/glu
	virtual/udev
	X? (
		x11-libs/libX11
		x11-libs/libXrandr
	)
	cg? ( media-gfx/nvidia-cg-toolkit )
	ffmpeg? ( media-video/ffmpeg:= )
	qt6? (
		dev-qt/qtbase:6[gui,network,opengl,widgets]
		dev-qt/qtsvg:6
	)
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)"

DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="
	virtual/pkgconfig
	qt6? ( dev-qt/qttools[linguist] )
	!qt6? ( dev-qt/linguist-tools:5 )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_GIT_INFO=OFF
		-DENABLE_QT6_LIBS=$(usex qt6)
		-DDISABLE_PORTABLE_MODE=OFF
		-DENABLE_FFMPEG=$(usex ffmpeg)
		-DENABLE_FULLSCREEN_RESFREQ=$(usex X)
		-DENABLE_OPENGL_CG=$(usex cg)
	)
	cmake_src_configure
}

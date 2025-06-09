# Copyright 1999-2025 Gentoo Authors
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
IUSE="X cg ffmpeg"

RDEPEND="
	dev-qt/qtbase:6[gui,network,opengl,widgets]
	dev-qt/qtsvg:6
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
"

DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="
	virtual/pkgconfig
	dev-qt/qttools[linguist]
"

PATCHES=(
	"${FILESDIR}/punes-0.111-FULLSCREEN_RESFREQ-fix.patch"
	"${FILESDIR}/punes-0.111-qt6.7_Q_OBJECT.patch"
	"${FILESDIR}/punes-0.111-qt6.9-compatibility.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_GIT_INFO=OFF
		-DENABLE_QT6_LIBS=ON
		-DDISABLE_PORTABLE_MODE=OFF
		-DENABLE_FFMPEG=$(usex ffmpeg)
		-DENABLE_FULLSCREEN_RESFREQ=$(usex X)
		-DENABLE_OPENGL_CG=$(usex cg)
	)
	cmake_src_configure
}

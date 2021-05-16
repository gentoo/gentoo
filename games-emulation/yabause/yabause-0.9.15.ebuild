# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Sega Saturn emulator"
HOMEPAGE="https://yabause.org/"
SRC_URI="https://download.tuxfamily.org/${PN}/releases/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openal opengl sdl"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	x11-libs/libXrandr
	x11-libs/libX11
	openal? ( media-libs/openal )
	opengl? (
		dev-qt/qtopengl:5
		media-libs/freeglut
		virtual/glu
		virtual/opengl
	)
	sdl? ( media-libs/libsdl2[opengl?,video] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-RWX.patch
	"${FILESDIR}"/${P}-qt-5.11.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF # bug 705338
		-DYAB_NETWORK=ON
		-DYAB_USE_CXX=ON
		-DYAB_USE_SCSP2=OFF # breaks build
		-DYAB_USE_SCSPMIDI=ON
		-DYAB_USE_SSF=ON
		-DSH2_DYNAREC=OFF # bug 582326
		-DYAB_OPTIMIZATION=""
		-DYAB_WANT_MPEG=OFF
		-DYAB_WANT_SDL=$(usex sdl)
		-DYAB_WANT_OPENAL=$(usex openal)
		-DYAB_WANT_OPENGL=$(usex opengl)
		-DYAB_PORTS=qt
	)
	cmake_src_configure
}

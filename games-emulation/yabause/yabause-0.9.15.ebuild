# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A Sega Saturn emulator"
HOMEPAGE="https://yabause.org/"
SRC_URI="https://download.tuxfamily.org/${PN}/releases/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openal opengl +qt5 sdl"

# Qt5 is the recommended UI and 0.9.15 the last release w/ GTK+
RDEPEND="
	sys-libs/zlib:=
	x11-libs/libXrandr
	x11-libs/libX11
	openal? ( media-libs/openal )
	opengl? (
		media-libs/freeglut
		virtual/glu
		virtual/opengl
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	!qt5? (
		dev-libs/glib:2
		x11-libs/gtk+:2
		x11-libs/gtkglext
	)
	sdl? ( media-libs/libsdl2[opengl?,video] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-RWX.patch
	"${FILESDIR}"/${P}-qt-5.11.patch
)

src_configure() {
	local mycmakeargs=(
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
		-DYAB_PORTS=$(usex qt5 "qt" "gtk")
	)
	cmake-utils_src_configure
}

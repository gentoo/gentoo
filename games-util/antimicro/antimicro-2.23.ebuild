# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils

DESCRIPTION="Map keyboard and mouse buttons to gamepad buttons"
HOMEPAGE="https://github.com/AntiMicro/antimicro"
SRC_URI="https://github.com/AntiMicro/antimicro/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/libsdl2[X,joystick]
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-linking-errors.patch" )

src_configure() {
	# TODO: Currently does not build w/o X
	# (!X would be: -DWITH_XTEST=OFF -DWITH_UINPUT=ON)
	local mycmakeargs=(
		-DUSE_QT5=ON
		-DUSE_SDL_2=ON
		-DWITH_X11=ON
		-DWITH_XTEST=ON
		-DWITH_UINPUT=OFF
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

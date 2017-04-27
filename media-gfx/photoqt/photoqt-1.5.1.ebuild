# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="Simple but powerful Qt-based image viewer"
HOMEPAGE="http://photoqt.org/"
SRC_URI="http://photoqt.org/pkgs/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="exiv2 graphicsmagick raw"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtimageformats:5
	dev-qt/qtmultimedia:5[qml]
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	exiv2? ( media-gfx/exiv2:= )
	graphicsmagick? ( >=media-gfx/graphicsmagick-1.3.20:= )
	raw? ( media-libs/libraw:= )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

src_configure() {
	local mycmakeargs=(
		-DEXIV2=$(usex exiv2)
		-DGM=$(usex graphicsmagick)
		-DRAW=$(usex raw)
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

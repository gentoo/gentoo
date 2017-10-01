# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils xdg-utils

DESCRIPTION="Qt4 wallpaper changer"
HOMEPAGE="http://www.becrux.com/index.php?page=projects&name=wally"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4
	dev-qt/qtsvg:4
	media-libs/libexif
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README README.XFCE4 README.shortcuts TODO )

PATCHES=( "${FILESDIR}"/${PN}-2.2.0-disable_popup.patch )

src_configure() {
	local mycmakeargs=(
		-DSTATIC=FALSE
		-DCMAKE_DISABLE_FIND_PACKAGE_KDE4=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newicon "${S}"/res/images/idle.png wally.png
	make_desktop_entry wally Wally wally "Graphics;Qt"
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

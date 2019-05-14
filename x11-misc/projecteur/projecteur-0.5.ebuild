# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/p/P}"

inherit cmake-utils desktop udev xdg-utils

DESCRIPTION="Linux Desktop Application for the Logitech Spotlight device"
HOMEPAGE="https://github.com/jahnf/Projecteur"
SRC_URI="https://github.com/jahnf/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtdeclarative:5=
	dev-qt/qtgui:5=[xcb]
	dev-qt/qtwidgets:5=
	dev-qt/qtx11extras:5=
	virtual/udev
	x11-libs/libX11:=
"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

src_install() {
	default

	newicon icons/projecteur-tray-64.png projecteur.png

	make_desktop_entry projecteur Projecteur projecteur Office
}

pkg_postinst() {
	udev_reload
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	udev_reload
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

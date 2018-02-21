# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils qmake-utils xdg-utils

DESCRIPTION="A fullscreen and distraction-free word processor"
HOMEPAGE="https://gottcode.org/focuswriter/"
SRC_URI="https://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# drop qtcore subslot when minimal Qt is 5.10
RDEPEND="
	app-text/hunspell:=
	dev-qt/qtcore:5=
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[qt5,X]
	dev-qt/qtwidgets:5
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	virtual/pkgconfig
"

DOCS=( ChangeLog CREDITS NEWS README )

PATCHES=( "${FILESDIR}/${PN}-1.6.0-unbundle-qtsingleapplication.patch" )

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

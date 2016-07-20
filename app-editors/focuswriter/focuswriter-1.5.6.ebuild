# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit fdo-mime gnome2-utils qmake-utils

DESCRIPTION="A fullscreen and distraction-free word processor"
HOMEPAGE="http://gottcode.org/focuswriter/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-text/hunspell
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[qt5,X]
	dev-qt/qtwidgets:5
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( ChangeLog CREDITS NEWS README )

PATCHES=( "${FILESDIR}/${PN}-1.5.6-unbundle-qtsingleapplication.patch" )

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

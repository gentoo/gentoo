# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PLOCALES="ar ca cs da de el en en_GB es_MX es fi fr he hu hy id it ja ko nl pl
pt_BR pt ro ru sk sr sv tr uk vi zh_CN zh_TW"
PLOCALE_BACKUP="en"
inherit fdo-mime gnome2-utils l10n readme.gentoo qt4-r2

DESCRIPTION="A fullscreen and distraction-free word processor"
HOMEPAGE="http://gottcode.org/focuswriter/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

RDEPEND="app-text/hunspell
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsingleapplication[qt4(+),X]
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog CREDITS NEWS README )
DOC_CONTENTS="Focuswriter has optional sound support if media-libs/sdl-mixer is
installed with wav useflag enabled."

PATCHES=( "${FILESDIR}/${PN}-1.5.2-unbundle-qtsingleapplication.patch" )

rm_loc() {
	sed -e "s|translations/${PN}_${1}.ts||"	-i ${PN}.pro || die 'sed failed'
	rm translations/${PN}_${1}.{ts,qm} || die "removing ${1} locale failed"
}

src_prepare() {
	l10n_for_each_disabled_locale_do rm_loc
	qt4-r2_src_prepare
}

src_configure() {
	eqmake4 PREFIX="${EPREFIX}/usr"
}

src_install() {
	readme.gentoo_create_doc
	qt4-r2_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	readme.gentoo_pkg_postinst
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

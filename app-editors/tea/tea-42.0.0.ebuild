# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="Small, lightweight Qt text editor"
HOMEPAGE="http://tea.ourproject.org/"
SRC_URI="http://tea.ourproject.org/dloads/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="aspell hunspell"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell:= )
"
DEPEND="${RDEPEND}
	hunspell? ( virtual/pkgconfig )
"

DOCS=( AUTHORS ChangeLog NEWS NEWS-RU TODO )

src_configure() {
	eqmake5 src.pro \
		$(use aspell || echo CONFIG+=noaspell) \
		$(use hunspell || echo CONFIG+=nohunspell)
}

src_install() {
	dobin bin/tea

	einstalldocs
	docinto html
	dodoc manuals/*.html

	insinto /usr/share/qt5/translations
	doins translations/${PN}_*.qm

	newicon icons/tea-icon-v3-01.png ${PN}.png
	make_desktop_entry ${PN} 'Tea Editor'
}

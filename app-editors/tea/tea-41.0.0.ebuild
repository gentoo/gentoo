# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="de fr ru"

inherit eutils l10n qmake-utils

DESCRIPTION="Small, lightweight Qt text editor"
HOMEPAGE="http://semiletov.org/tea/ http://tea.ourproject.org/"
SRC_URI="http://semiletov.org/${PN}/dloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86 ~x86-fbsd"
IUSE="aspell hunspell"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	sys-libs/zlib
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell )
"
DEPEND="${RDEPEND}
	hunspell? ( virtual/pkgconfig )
"

DOCS=( AUTHORS ChangeLog NEWS TODO )

src_configure() {
	eqmake4 src.pro \
		$(use aspell || echo CONFIG+=noaspell) \
		$(use hunspell || echo CONFIG+=nohunspell)
}

src_install() {
	dobin bin/tea

	newicon icons/tea-icon-v3-01.png ${PN}.png
	make_desktop_entry ${PN} 'Tea Editor'

	# translations
	insinto /usr/share/qt4/translations
	local lang
	for lang in $(l10n_get_locales); do
		doins translations/${PN}_${lang}.qm
	done

	# docs
	dohtml manuals/en.html
	if use linguas_ru; then
		dodoc NEWS-RU
		dohtml manuals/ru.html
	fi
}

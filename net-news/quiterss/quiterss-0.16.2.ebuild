# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/quiterss/quiterss-0.16.2.ebuild,v 1.5 2015/05/10 13:09:27 pesa Exp $

EAPI=5

PLOCALES="ar cs de el_GR es fa fi fr gl hu it ja ko lt nl pl pt_BR pt_PT ro_RO ru sk sr sv tg_TJ tr uk vi zh_CN zh_TW"
EHG_REPO_URI="https://code.google.com/p/quite-rss"
inherit qt4-r2 l10n fdo-mime gnome2-utils
[[ ${PV} == *9999* ]] && inherit mercurial

[[ ${PV} == *9999* ]] || \
MY_P="QuiteRSS-${PV}-src"

DESCRIPTION="A Qt4-based RSS/Atom feed reader"
HOMEPAGE="https://quiterss.org"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://quiterss.org/files/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug phonon"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsingleapplication[X,qt4(+)]
	dev-qt/qtsql:4[sqlite]
	dev-qt/qtwebkit:4
	dev-db/sqlite:3
	phonon? ( || ( media-libs/phonon[qt4] dev-qt/qtphonon:4 ) )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

[[ ${PV} == *9999* ]] || \
S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS HISTORY_EN HISTORY_RU README )

src_prepare() {
	my_rm_loc() {
		sed -i -e "s:lang/${PN}_${1}.ts::" lang/lang.pri || die
	}
	# dedicated english locale file is not installed at all
	rm "lang/${PN}_en.ts" || die

	l10n_find_plocales_changes "lang" "${PN}_" '.ts'
	l10n_for_each_disabled_locale_do my_rm_loc

	qt4-r2_src_prepare
}

src_configure() {
	eqmake4 PREFIX="${EPREFIX}/usr" \
		SYSTEMQTSA=1 \
		$(usex phonon '' 'DISABLE_PHONON=1')
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/quiterss/quiterss-0.17.6.ebuild,v 1.2 2015/05/10 13:09:27 pesa Exp $

EAPI=5
PLOCALES="ar bg cs de el_GR es fa fi fr gl hi hu it ja ko lt nl pl pt_BR pt_PT ro_RO ru sk sr sv tg_TJ tr uk vi zh_CN zh_TW"

if [[ ${PV} == *9999* ]]; then
	EHG_REPO_URI="https://code.google.com/p/quite-rss"
	inherit mercurial
	KEYWORDS=""
else
	MY_P="QuiteRSS-${PV}-src"
	SRC_URI="https://quiterss.org/files/${PV}/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${MY_P}"
fi

inherit fdo-mime gnome2-utils l10n qmake-utils

DESCRIPTION="A Qt-based RSS/Atom feed reader"
HOMEPAGE="https://quiterss.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug phonon"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsingleapplication[X,qt4(+)]
	dev-qt/qtsql:4[sqlite]
	dev-qt/qtwebkit:4
	phonon? ( || ( media-libs/phonon[qt4] dev-qt/qtphonon:4 ) )
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS HISTORY_EN HISTORY_RU README )

src_prepare() {
	my_rm_loc() {
		sed -i -e "s:lang/${PN}_${1}.ts::" lang/lang.pri || die
	}
	# dedicated english locale file is not installed at all
	rm "lang/${PN}_en.ts" || die

	l10n_find_plocales_changes "lang" "${PN}_" '.ts'
	l10n_for_each_disabled_locale_do my_rm_loc
}

src_configure() {
	eqmake4 PREFIX="${EPREFIX}/usr" SYSTEMQTSA=1 \
		$(usex phonon '' 'DISABLE_PHONON=1')
}

src_install() {
	emake INSTALL_ROOT="${D}" install
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

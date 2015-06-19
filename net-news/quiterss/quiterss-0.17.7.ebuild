# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/quiterss/quiterss-0.17.7.ebuild,v 1.1 2015/04/21 16:34:29 maksbotan Exp $

EAPI=5

PLOCALES="ar bg cs de el_GR es fa fi fr gl hi hu it ja ko lt nl pl pt_BR pt_PT ro_RO ru sk sr sv tg_TJ tr uk vi zh_CN zh_TW"
EGIT_REPO_URI="https://github.com/QuiteRSS/quiterss.git"
inherit eutils l10n fdo-mime gnome2-utils qmake-utils
[[ ${PV} == *9999* ]] && inherit git-r3

DESCRIPTION="A Qt-based RSS/Atom feed reader"
HOMEPAGE="https://quiterss.org"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://github.com/QuiteRSS/quiterss/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug phonon +qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND="
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsql:4[sqlite]
		dev-qt/qtwebkit:4
		phonon? ( || ( media-libs/phonon[qt4] dev-qt/qtphonon:4 ) )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	dev-qt/qtsingleapplication[X,qt4(+)?,qt5(-)?]
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS HISTORY_EN HISTORY_RU README )

src_prepare() {
	my_rm_loc() {
		sed -i -e "s:lang/${PN}_${1}.ts::" lang/lang.pri || die
	}

	epatch_user

	# dedicated english locale file is not installed at all
	rm "lang/${PN}_en.ts" || die

	l10n_find_plocales_changes "lang" "${PN}_" '.ts'
	l10n_for_each_disabled_locale_do my_rm_loc
}

src_configure() {
	use qt4 && eqmake4 PREFIX="${EPREFIX}/usr" \
		SYSTEMQTSA=1 \
		$(usex phonon '' 'DISABLE_PHONON=1')
	use qt5 && eqmake5 PREFIX="${EPREFIX}/usr" \
		SYSTEMQTSA=1
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
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

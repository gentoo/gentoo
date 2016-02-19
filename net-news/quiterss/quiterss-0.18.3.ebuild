# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PLOCALES="ar bg cs de el_GR es fa fi fr gl hi hu it ja ko lt nl pl pt_BR pt_PT ro_RO ru sk sr sv tg_TJ tr uk vi zh_CN zh_TW"
inherit eutils l10n fdo-mime gnome2-utils qmake-utils

DESCRIPTION="A Qt-based RSS/Atom feed reader"
HOMEPAGE="https://quiterss.org"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/QuiteRSS/quiterss.git"
	inherit git-r3
else
	SRC_URI="https://github.com/QuiteRSS/quiterss/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="debug phonon +qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND=">=dev-db/sqlite-3.10.0:3
	dev-qt/qtsingleapplication[X,qt4(+)?,qt5(-)?]
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsql:4[sqlite]
		dev-qt/qtwebkit:4
		phonon? ( || ( media-libs/phonon[qt4] dev-qt/qtphonon:4 ) ) )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS CHANGELOG README.md )

src_prepare() {
	my_rm_loc() {
		sed -i -e "s:lang/${PN}_${1}.ts::" lang/lang.pri || die
	}

	default

	# dedicated english locale file is not installed at all
	rm "lang/${PN}_en.ts" || die

	l10n_find_plocales_changes "lang" "${PN}_" '.ts'
	l10n_for_each_disabled_locale_do my_rm_loc
}

src_configure() {
	use qt4 && eqmake4 PREFIX="${EPREFIX}/usr" SYSTEMQTSA=1 \
		$(usex phonon '' 'DISABLE_PHONON=1')
	use qt5 && eqmake5 PREFIX="${EPREFIX}/usr" SYSTEMQTSA=1
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

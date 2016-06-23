# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PLOCALES="ar bg cs de el_GR es fa fi fr gl he hi hu it ja ko lt nl pl pt_BR pt_PT ro_RO ru sk sr sv tg_TJ th_TH tr uk vi zh_CN zh_TW"

inherit fdo-mime gnome2-utils l10n qmake-utils

DESCRIPTION="A Qt-based RSS/Atom feed reader"
HOMEPAGE="https://quiterss.org"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/QuiteRSS/quiterss.git"
	inherit git-r3
else
	SRC_URI="https://github.com/QuiteRSS/quiterss/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="phonon qt5"

RDEPEND=">=dev-db/sqlite-3.11.1:3
	!qt5? ( dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsingleapplication[X,qt4(+)]
		dev-qt/qtsql:4[sqlite]
		dev-qt/qtwebkit:4
		phonon? ( || ( media-libs/phonon[qt4] dev-qt/qtphonon:4 ) ) )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsingleapplication[X,qt5(-)]
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS CHANGELOG README.md )

src_prepare() {
	default

	my_rm_loc() {
		sed -i -e "s:lang/${PN}_${1}.ts::" lang/lang.pri || die
	}

	# dedicated english locale file is not installed at all
	rm "lang/${PN}_en.ts" || die

	l10n_find_plocales_changes lang ${PN}_ .ts
	l10n_for_each_disabled_locale_do my_rm_loc
}

src_configure() {
	local myqmakeargs=(
		PREFIX="${EPREFIX}/usr"
		SYSTEMQTSA=1
	)
	if use qt5; then
		eqmake5 "${myqmakeargs[@]}"
	else
		eqmake4 "${myqmakeargs[@]}" \
			$(usex phonon '' 'DISABLE_PHONON=1')
	fi
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

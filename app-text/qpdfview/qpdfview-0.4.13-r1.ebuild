# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PLOCALES="ast az bg bs ca cs da de el en_GB eo es eu fi fr gl he hr id it kk ko ky lt ms my pl pt pt_BR ro ru sk sv tr ug uk vi zh_CN"
inherit eutils l10n multilib qmake-utils

DESCRIPTION="A tabbed document viewer"
HOMEPAGE="http://launchpad.net/qpdfview"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
IUSE="cups dbus djvu fitz +pdf postscript +qt4 qt5 sqlite +svg synctex"

REQUIRED_USE="^^ ( qt4 qt5 )
	?? ( fitz pdf )"

RDEPEND="cups? ( net-print/cups )
	djvu? ( app-text/djvu )
	fitz? ( app-text/mupdf:0/1.4 )
	postscript? ( app-text/libspectre )
	qt4? ( dev-qt/qtcore:4[iconv]
		dev-qt/qtgui:4
		dbus? ( dev-qt/qtdbus:4 )
		pdf? ( app-text/poppler[qt4] )
		sqlite? ( dev-qt/qtsql:4[sqlite] )
		svg? ( dev-qt/qtsvg:4 ) )
	qt5? ( dev-qt/linguist-tools:5
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dbus? ( dev-qt/qtdbus:5 )
		pdf? ( >=app-text/poppler-0.26.4[qt5] )
		sqlite? ( dev-qt/qtsql:5[sqlite] )
		svg? ( dev-qt/qtsvg:5 ) )
	!svg? ( virtual/freedesktop-icon-theme )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( CHANGES CONTRIBUTORS README TODO )

src_prepare() {
	prepare_locale() {
		local _lrel
		use qt4 && _lrel="$(qt4_get_bindir)/lrelease"
		use qt5 && _lrel="$(qt5_get_bindir)/lrelease"
		${_lrel} "translations/${PN}_${1}.ts" || die "preparing ${1} locale failed"
	}

	rm_help() {
		rm -f "miscellaneous/help_${1}.html" || die "removing extraneous help files failed"
	}

	l10n_find_plocales_changes translations "${PN}_" '.ts'
	l10n_for_each_locale_do prepare_locale
	l10n_for_each_disabled_locale_do rm_help

	# adapt for prefix
	sed -i -e "s:/usr:${EPREFIX}/usr:g" qpdfview.pri || die
}

src_configure() {
	local config i
	for i in cups dbus pdf djvu svg synctex; do
		if ! use ${i}; then
			config+=" without_${i}"
		fi
	done

	use fitz && config+=" with_fitz"
	use postscript || config+=" without_ps"
	use sqlite || config+=" without_sql"

	if use qt4; then
		eqmake4 CONFIG+="${config}" PLUGIN_INSTALL_PATH="${EPREFIX}/usr/$(get_libdir)/${PN}"
	else
		eqmake5 CONFIG+="${config}" PLUGIN_INSTALL_PATH="${EPREFIX}/usr/$(get_libdir)/${PN}" qpdfview.pro
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

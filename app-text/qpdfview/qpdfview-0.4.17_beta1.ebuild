# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="ast az be bg bs ca cs da de el en_GB eo es eu fi fr gl he hr hu id it kk ko ky lt ms my pl pt pt_BR ro ru sk sv th tr ug uk vi zh_CN"

inherit l10n qmake-utils

DESCRIPTION="A tabbed document viewer"
HOMEPAGE="https://launchpad.net/qpdfview"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV/_/}/+download/${P/_/}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="cups +dbus djvu fitz +pdf postscript qt5 +sqlite +svg synctex"

REQUIRED_USE="?? ( fitz pdf )"

RDEPEND="
	cups? ( net-print/cups )
	djvu? ( app-text/djvu )
	fitz? ( >=app-text/mupdf-1.7:= )
	postscript? ( app-text/libspectre )
	!qt5? ( dev-qt/qtcore:4[iconv]
		dev-qt/qtgui:4
		sys-apps/file
		dbus? ( dev-qt/qtdbus:4 )
		pdf? ( >=app-text/poppler-0.35[qt4] )
		sqlite? ( dev-qt/qtsql:4[sqlite] )
		svg? ( dev-qt/qtsvg:4 ) )
	qt5? ( dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		dbus? ( dev-qt/qtdbus:5 )
		pdf? ( >=app-text/poppler-0.35[qt5]
			dev-qt/qtxml:5 )
		sqlite? ( dev-qt/qtsql:5[sqlite] )
		svg? ( dev-qt/qtsvg:5 ) )
	!svg? ( virtual/freedesktop-icon-theme )
	synctex? ( app-text/texlive-core )"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
	virtual/pkgconfig"

DOCS=( CHANGES CONTRIBUTORS README TODO )

S="${WORKDIR}/${P/_/}"

src_prepare() {
	local mylrelease="$(qt4_get_bindir)"/lrelease
	use qt5 && mylrelease="$(qt5_get_bindir)"/lrelease

	prepare_locale() {
		"${mylrelease}" "translations/${PN}_${1}.ts" || die "preparing ${1} locale failed"
	}

	rm_help() {
		rm -f "help/help_${1}.html" || die "removing ${1} help file failed"
	}

	l10n_find_plocales_changes translations ${PN}_ .ts
	l10n_for_each_locale_do prepare_locale
	l10n_for_each_disabled_locale_do rm_help

	# adapt for prefix
	sed -i -e "s:/usr:${EPREFIX}/usr:g" qpdfview.pri || die

	default
}

src_configure() {
	local myconfig=() i=
	for i in cups dbus djvu pdf svg synctex; do
		use ${i} || myconfig+=(without_${i})
	done
	use fitz && myconfig+=(with_fitz)
	use postscript || myconfig+=(without_ps)
	use sqlite || myconfig+=(without_sql)

	local myqmakeargs=(
		qpdfview.pro
		CONFIG+="${myconfig[@]}"
		PLUGIN_INSTALL_PATH="${EPREFIX}/usr/$(get_libdir)/${PN}"
	)
	if use qt5; then
		eqmake5 "${myqmakeargs[@]}"
	else
		eqmake4 "${myqmakeargs[@]}"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

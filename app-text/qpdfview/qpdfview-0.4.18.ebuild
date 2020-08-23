# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="ast az be bg bs ca cs da de el en_AU en_GB eo es eu fa fi fr gl he hr hu id it ja kk ko ku ky lt lv ms my nb nds oc pl pt pt_BR ro ru sk sr sv th tr ug uk uz vi zh_CN zh_TW"
inherit l10n qmake-utils xdg

DESCRIPTION="A tabbed document viewer"
HOMEPAGE="https://launchpad.net/qpdfview"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="cups +dbus djvu fitz +pdf postscript +sqlite +svg synctex"

REQUIRED_USE="?? ( fitz pdf )"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	cups? ( net-print/cups )
	djvu? ( app-text/djvu )
	fitz? ( >=app-text/mupdf-1.7:= )
	postscript? ( app-text/libspectre )
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5[cups?]
	dev-qt/qtwidgets:5
	dbus? ( dev-qt/qtdbus:5 )
	pdf? ( >=app-text/poppler-0.35[qt5]
		dev-qt/qtxml:5 )
	sqlite? ( dev-qt/qtsql:5[sqlite] )
	svg? ( dev-qt/qtsvg:5 )
	!svg? ( virtual/freedesktop-icon-theme )
	synctex? ( app-text/texlive-core )"
DEPEND="${RDEPEND}"

DOCS=( CHANGES CONTRIBUTORS README TODO )

PATCHES=( "${FILESDIR}/${P}-qt-5.15.patch" ) # bug 726064

src_prepare() {
	default

	local mylrelease="$(qt5_get_bindir)"/lrelease
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
	eqmake5 "${myqmakeargs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

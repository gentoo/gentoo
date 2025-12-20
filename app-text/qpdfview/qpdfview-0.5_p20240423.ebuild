# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="af ast az be ber bg bs ca cs da de el en_AU en_GB eo es eu fa fi fr gl he hi hr hu id it ja kk ko ku ky lt lv ms my nb nds oc pl pt pt_BR ro ru rue sk sr sv th tr ug uk uz vi zgh zh_CN zh_TW"
PRE_EXISTING_TARNAME="${PN}-0.5_p2" # TODO: drop on next bump
REVISION=2162
inherit plocale qmake-utils xdg

DESCRIPTION="Tabbed document viewer"
HOMEPAGE="https://launchpad.net/qpdfview"
SRC_URI="https://bazaar.launchpad.net/~adamreichold/${PN}/trunk/tarball/${REVISION} -> ${PRE_EXISTING_TARNAME}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="cups +dbus djvu fitz +pdf postscript +sqlite +svg synctex"

REQUIRED_USE="?? ( fitz pdf )"

BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtbase:6[concurrent,dbus?,gui,widgets]
	cups? ( net-print/cups )
	djvu? ( app-text/djvu )
	fitz? ( >=app-text/mupdf-1.7:= )
	pdf? ( app-text/poppler[qt6] )
	postscript? ( app-text/libspectre )
	sqlite? ( dev-qt/qtbase:6[sql,sqlite] )
	svg? ( dev-qt/qtsvg:6 )
	!svg? ( virtual/freedesktop-icon-theme )
	synctex? ( app-text/texlive-core )"
DEPEND="${RDEPEND}"

DOCS=( CHANGES CONTRIBUTORS README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.5-poppler-23.08.0-cxx17.patch
)

src_unpack() {
	unpack ${A}
	mv '~adamreichold'/${PN}/trunk ${PN}-${PV} || die "mv trunk failed"
}

src_prepare() {
	default

	local mylrelease="$(qt6_get_bindir)"/lrelease

	p_locale() {
		"${mylrelease}" "translations/${PN}_${1}.ts" || die "preparing ${1} locale failed"
	}

	rm_help() {
		rm -f "help/help_${1}.html" || die "removing ${1} help file failed"
	}

	plocale_find_changes translations ${PN}_ .ts
	plocale_for_each_locale p_locale
	plocale_for_each_disabled_locale rm_help

	# adapt for prefix
	sed -i -e "s:/usr:${EPREFIX}/usr:g" qpdfview.pri || die
}

src_configure() {
	local myconfig=() i
	for i in cups dbus djvu pdf svg synctex; do
		use ${i} || myconfig+=( without_${i} )
	done
	use fitz && myconfig+=( with_fitz )
	use postscript || myconfig+=( without_ps )
	use sqlite || myconfig+=( without_sql )

	local myqmakeargs=(
		qpdfview.pro
		CONFIG+="${myconfig[*]}"
		$(usex fitz FITZ_PLUGIN_LIBS="-lmupdf" "")
		PLUGIN_INSTALL_PATH="${EPREFIX}/usr/$(get_libdir)/${PN}"
	)

	eqmake6 "${myqmakeargs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

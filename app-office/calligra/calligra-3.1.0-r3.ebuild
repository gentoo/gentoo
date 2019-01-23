# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CHECKREQS_DISK_BUILD="4G"
KDE_DOC_DIR="xxx" # contains no language subdirs
KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
inherit check-reqs kde5

DESCRIPTION="KDE Office Suite"
HOMEPAGE="https://www.calligra.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

CAL_FTS=( karbon sheets stage words )

IUSE="activities +crypt +fontconfig gemini gsl import-filter +lcms okular openexr +pdf
	phonon pim spacenav +truetype X $(printf 'calligra_features_%s ' ${CAL_FTS[@]})"

# TODO: Not packaged: Cauchy (https://bitbucket.org/cyrille/cauchy)
# Required for the matlab/octave formula tool
COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kross)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep designer)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-lang/perl
	sys-libs/zlib
	virtual/libiconv
	activities? ( $(add_frameworks_dep kactivities) )
	crypt? ( app-crypt/qca:2[qt5(+)] )
	fontconfig? ( media-libs/fontconfig )
	gemini? ( $(add_qt_dep qtdeclarative 'widgets') )
	gsl? ( sci-libs/gsl )
	import-filter? (
		$(add_frameworks_dep khtml)
		app-text/libetonyek
		app-text/libodfgen
		app-text/libwpd:*
		app-text/libwpg:*
		>=app-text/libwps-0.4
		dev-libs/librevenge
		media-libs/libvisio
	)
	lcms? (
		media-libs/ilmbase:=
		media-libs/lcms:2
	)
	openexr? ( media-libs/openexr )
	pdf? ( >=app-text/poppler-0.64:=[qt5] )
	phonon? ( media-libs/phonon[qt5(+)] )
	pim? ( $(add_kdeapps_dep kcalcore) )
	spacenav? ( dev-libs/libspnav )
	truetype? ( media-libs/freetype:2 )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
	)
	calligra_features_sheets? ( dev-cpp/eigen:3 )
	calligra_features_stage? ( okular? ( $(add_kdeapps_dep okular) ) )
	calligra_features_words? (
		dev-libs/libxslt
		okular? ( $(add_kdeapps_dep okular) )
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	sys-devel/gettext
	x11-misc/shared-mime-info
	test? ( $(add_frameworks_dep threadweaver) )
"
RDEPEND="${COMMON_DEPEND}
	calligra_features_karbon? ( media-gfx/pstoedit[plotutils] )
	!app-office/calligra:4
	!app-office/calligra-l10n:4
"
RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}"/${P}-no-arch-detection.patch
	"${FILESDIR}"/${P}-doc.patch
	"${FILESDIR}"/${P}-qt-5.11.patch
	"${FILESDIR}"/${P}-stage-qt-5.11.patch
	"${FILESDIR}"/${P}-poppler-0.69.patch
	"${FILESDIR}"/${P}-poppler-0.71.patch
	"${FILESDIR}"/${P}-no-webkit.patch
)

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	kde5_pkg_setup
	check-reqs_pkg_setup
}

src_prepare() {
	kde5_src_prepare

	if ! use test; then
		sed -e "/add_subdirectory( *benchmarks *)/s/^/#DONT/" \
			-i libs/pigment/CMakeLists.txt || die
	fi

	# Unconditionally disable deprecated deps (required by QtQuick1)
	punt_bogus_dep Qt5 Declarative
	punt_bogus_dep Qt5 OpenGL

	# Hack around the excessive use of CMake macros
	if use okular && ! use calligra_features_words; then
		sed -i -e "/add_subdirectory( *okularodtgenerator *)/ s/^/#DONT/" \
			extras/CMakeLists.txt || die "Failed to disable OKULAR_GENERATOR_ODT"
	fi

	if use okular && ! use calligra_features_stage; then
		sed -i -e "/add_subdirectory( *okularodpgenerator *)/ s/^/#DONT/" \
			extras/CMakeLists.txt || die "Failed to disable OKULAR_GENERATOR_ODP"
	fi
}

src_configure() {
	local cal_ft myproducts

	# applications
	for cal_ft in ${CAL_FTS[@]}; do
		use calligra_features_${cal_ft} && myproducts+=( "${cal_ft^^}" )
	done

	use lcms && myproducts+=( PLUGIN_COLORENGINES )
	use spacenav && myproducts+=( PLUGIN_SPACENAVIGATOR )

	local mycmakeargs=(
		-DPACKAGERS_BUILD=OFF
		-DRELEASE_BUILD=ON
		-DWITH_Iconv=ON
		-DPRODUCTSET="${myproducts[*]}"
		$(cmake-utils_use_find_package activities KF5Activities)
		-DWITH_Qca-qt5=$(usex crypt)
		-DWITH_Fontconfig=$(usex fontconfig)
		$(cmake-utils_use_find_package gemini Libgit2)
		$(cmake-utils_use_find_package gemini Qt5QuickWidgets)
		-DWITH_GSL=$(usex gsl)
		-DWITH_LibEtonyek=$(usex import-filter)
		-DWITH_LibOdfGen=$(usex import-filter)
		-DWITH_LibRevenge=$(usex import-filter)
		-DWITH_LibVisio=$(usex import-filter)
		-DWITH_LibWpd=$(usex import-filter)
		-DWITH_LibWpg=$(usex import-filter)
		-DWITH_LibWps=$(usex import-filter)
		$(cmake-utils_use_find_package phonon Phonon4Qt5)
		$(cmake-utils_use_find_package pim KF5CalendarCore)
		-DWITH_LCMS2=$(usex lcms)
		-DWITH_Okular5=$(usex okular)
		-DWITH_OpenEXR=$(usex openexr)
		-DWITH_Poppler=$(usex pdf)
		-DWITH_Eigen3=$(usex calligra_features_sheets)
		-DBUILD_UNMAINTAINED=$(usex calligra_features_stage)
		-ENABLE_CSTESTER_TESTING=$(usex test)
		-DWITH_Freetype=$(usex truetype)
	)

	kde5_src_configure
}

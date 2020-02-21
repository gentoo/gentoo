# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHECKREQS_DISK_BUILD="4G"
ECM_HANDBOOK_DIR="xxx" # contains no language subdirs
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit check-reqs ecm

DESCRIPTION="KDE Office Suite"
HOMEPAGE="https://www.calligra.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 x86"

CAL_FTS=( karbon sheets stage words )

IUSE="activities +charts +crypt +fontconfig gemini gsl import-filter +lcms okular openexr
	+pdf phonon spacenav +truetype X $(printf 'calligra_features_%s ' ${CAL_FTS[@]})"

# TODO: Not packaged: Cauchy (https://bitbucket.org/cyrille/cauchy)
# Required for the matlab/octave formula tool
BDEPEND="
	sys-devel/gettext
"
COMMON_DEPEND="
	dev-lang/perl
	>=dev-qt/designer-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtscript-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kemoticons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kross-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	sys-libs/zlib
	virtual/libiconv
	activities? ( >=kde-frameworks/kactivities-${KFMIN}:5 )
	charts? ( dev-libs/kdiagram:5 )
	crypt? ( app-crypt/qca:2[qt5(+)] )
	fontconfig? ( media-libs/fontconfig )
	gemini? ( >=dev-qt/qtdeclarative-${QTMIN}:5[widgets] )
	gsl? ( sci-libs/gsl )
	import-filter? (
		app-text/libetonyek
		app-text/libodfgen
		app-text/libwpd:*
		app-text/libwpg:*
		>=app-text/libwps-0.4
		dev-libs/librevenge
		>=kde-frameworks/khtml-${KFMIN}:5
		media-libs/libvisio
	)
	lcms? (
		media-libs/ilmbase:=
		media-libs/lcms:2
	)
	openexr? ( media-libs/openexr )
	pdf? ( >=app-text/poppler-0.73:=[qt5] )
	phonon? ( media-libs/phonon[qt5(+)] )
	spacenav? ( dev-libs/libspnav )
	truetype? ( media-libs/freetype:2 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
	)
	calligra_features_sheets? ( dev-cpp/eigen:3 )
	calligra_features_stage? ( okular? ( >=kde-apps/okular-19.04.3:5 ) )
	calligra_features_words? (
		dev-libs/libxslt
		okular? ( >=kde-apps/okular-19.04.3:5 )
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	test? ( >=kde-frameworks/threadweaver-${KFMIN}:5 )
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
	"${FILESDIR}"/${P}-{,stage-}qt-5.11.patch
	"${FILESDIR}"/${P}-poppler-0.{69,71,72,73}.patch
	"${FILESDIR}"/${P}-no-webkit.patch
	"${FILESDIR}"/${P}-missing-header.patch
)

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	ecm_pkg_setup
	check-reqs_pkg_setup
}

src_prepare() {
	ecm_src_prepare

	if has_version ">=app-text/poppler-0.82"; then
		eapply "${FILESDIR}/${P}-poppler-0.82.patch" # TODO: make upstreamable patch
	fi

	if has_version ">=app-text/poppler-0.83"; then
		eapply "${FILESDIR}/${P}-poppler-0.83.patch" # TODO: make upstreamable patch
	fi

	if ! use test; then
		sed -e "/add_subdirectory( *benchmarks *)/s/^/#DONT/" \
			-i libs/pigment/CMakeLists.txt || die
	fi

	# Unconditionally disable deprecated deps (required by QtQuick1)
	ecm_punt_bogus_dep Qt5 Declarative
	ecm_punt_bogus_dep Qt5 OpenGL

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
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package charts KChart)
		-DWITH_Qca-qt5=$(usex crypt)
		-DWITH_Fontconfig=$(usex fontconfig)
		$(cmake_use_find_package gemini Libgit2)
		$(cmake_use_find_package gemini Qt5QuickWidgets)
		-DWITH_GSL=$(usex gsl)
		-DWITH_LibEtonyek=$(usex import-filter)
		-DWITH_LibOdfGen=$(usex import-filter)
		-DWITH_LibRevenge=$(usex import-filter)
		-DWITH_LibVisio=$(usex import-filter)
		-DWITH_LibWpd=$(usex import-filter)
		-DWITH_LibWpg=$(usex import-filter)
		-DWITH_LibWps=$(usex import-filter)
		$(cmake_use_find_package phonon Phonon4Qt5)
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5CalendarCore=ON
		-DWITH_LCMS2=$(usex lcms)
		-DWITH_Okular5=$(usex okular)
		-DWITH_OpenEXR=$(usex openexr)
		-DWITH_Poppler=$(usex pdf)
		-DWITH_Eigen3=$(usex calligra_features_sheets)
		-DBUILD_UNMAINTAINED=$(usex calligra_features_stage)
		-ENABLE_CSTESTER_TESTING=$(usex test)
		-DWITH_Freetype=$(usex truetype)
	)

	ecm_src_configure
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="4G"
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=5.88.0
QTMIN=5.15.2
inherit check-reqs ecm flag-o-matic kde.org

DESCRIPTION="KDE Office Suite"
HOMEPAGE="https://calligra.org/"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~ppc64 ~riscv x86"
fi

CAL_FTS=( karbon sheets stage words )

LICENSE="GPL-2"
SLOT="5"
IUSE="activities +charts +crypt +fontconfig gemini gsl +import-filter +lcms
	okular +pdf phonon spacenav +truetype X
	$(printf 'calligra_features_%s ' ${CAL_FTS[@]})"

RESTRICT="test"

# TODO: Not packaged: Cauchy (https://bitbucket.org/cyrille/cauchy)
# Required for the matlab/octave formula tool
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
	crypt? ( >=app-crypt/qca-2.3.0:2 )
	fontconfig? ( media-libs/fontconfig )
	gemini? ( >=dev-qt/qtdeclarative-${QTMIN}:5[widgets] )
	gsl? ( sci-libs/gsl:= )
	import-filter? (
		app-text/libetonyek
		app-text/libodfgen
		app-text/libwpd:*
		app-text/libwpg:*
		>=app-text/libwps-0.4
		dev-libs/librevenge
		media-libs/libvisio
	)
	lcms? ( media-libs/lcms:2 )
	okular? ( kde-apps/okular:5 )
	pdf? ( app-text/poppler:=[qt5] )
	phonon? ( >=media-libs/phonon-4.11.0 )
	spacenav? ( dev-libs/libspnav )
	truetype? ( media-libs/freetype:2 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
	)
	calligra_features_sheets? ( dev-cpp/eigen:3 )
	calligra_features_words? ( dev-libs/libxslt )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	lcms? ( dev-libs/imath:3 )
	test? ( >=kde-frameworks/threadweaver-${KFMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	calligra_features_karbon? ( media-gfx/pstoedit[plotutils] )
	gemini? (
		>=dev-qt/qtquickcontrols-${QTMIN}:5
		>=dev-qt/qtquickcontrols2-${QTMIN}:5
		>=kde-frameworks/kirigami-${KFMIN}:5
	)
"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.89-no-arch-detection.patch
	"${FILESDIR}"/${P}-cmake-3.16.patch # bug 796224
	"${FILESDIR}"/${P}-{openexr-3,imath-{1,2}}.patch
	"${FILESDIR}"/${P}-cxx17-for-poppler-22.patch
	"${FILESDIR}"/${P}-cxx17-fixes.patch
	"${FILESDIR}"/${P}-poppler-22.03.0-{1,2}.patch
	"${FILESDIR}"/${P}-poppler-22.04.0.patch
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

	# Unconditionally disable deprecated deps (required by QtQuick1)
	ecm_punt_bogus_dep Qt5 Declarative
	ecm_punt_bogus_dep Qt5 OpenGL
}

src_configure() {
	local cal_ft myproducts

	# Uses removed 'register' keyword, drop on next release. bug #883067
	append-cxxflags -std=c++14

	# applications
	for cal_ft in ${CAL_FTS[@]}; do
		use calligra_features_${cal_ft} && myproducts+=( "${cal_ft^^}" )
	done

	use lcms && myproducts+=( PLUGIN_COLORENGINES )
	use okular && myproducts+=( OKULAR )
	use spacenav && myproducts+=( PLUGIN_SPACENAVIGATOR )

	local mycmakeargs=(
		-DPACKAGERS_BUILD=OFF
		-DRELEASE_BUILD=ON
		-DWITH_Iconv=ON
		-DWITH_Imath=ON # w/ LCMS: 16 bit floating point Grayscale colorspace
		-DCMAKE_DISABLE_FIND_PACKAGE_Cauchy=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5CalendarCore=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5KHtml=ON
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
		-DWITH_LCMS2=$(usex lcms)
		-DWITH_Okular5=$(usex okular)
		-DWITH_Poppler=$(usex pdf)
		-DWITH_Eigen3=$(usex calligra_features_sheets)
		-DBUILD_UNMAINTAINED=$(usex calligra_features_stage)
		-DWITH_Freetype=$(usex truetype)
	)

	ecm_src_configure
}

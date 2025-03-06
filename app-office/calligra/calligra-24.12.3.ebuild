# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="4G"
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.9.0
QTMIN=6.8.0
inherit check-reqs ecm gear.kde.org xdg

DESCRIPTION="KDE Office Suite"
HOMEPAGE="https://calligra.org/"
PATCHSET="${PN}-3.2.1-patchset-1"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
if [[ ${KDE_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi
CAL_FTS=( karbon sheets stage words )
IUSE="+charts +fontconfig gsl +import-filter +lcms okular +pdf phonon
	+truetype webengine X $(printf 'calligra_features_%s ' ${CAL_FTS[@]})"

RESTRICT="test"

# TODO: Not packaged: Cauchy (https://bitbucket.org/cyrille/cauchy)
# Required for the matlab/octave formula tool
COMMON_DEPEND="
	dev-lang/perl
	dev-libs/openssl:=
	>=dev-libs/qtkeychain-0.14.2:=[qt6(+)]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qttools-${QTMIN}:6[designer]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	sys-libs/zlib
	virtual/libiconv
	charts? ( dev-libs/kdiagram:6 )
	fontconfig? ( media-libs/fontconfig )
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
	okular? ( kde-apps/okular:6 )
	pdf? ( app-text/poppler:=[qt6] )
	phonon? ( >=media-libs/phonon-4.12.0[qt6(+)] )
	truetype? ( media-libs/freetype:2 )
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:6[widgets] )
	calligra_features_sheets? ( dev-cpp/eigen:3 )
	calligra_features_words? ( dev-libs/libxslt )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	lcms? ( dev-libs/imath:3 )
	test? ( >=kde-frameworks/threadweaver-${KFMIN}:6 )
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5
	calligra_features_karbon? ( media-gfx/pstoedit[plotutils] )
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=( "${WORKDIR}"/${PATCHSET}/${PN}-3.1.89-no-arch-detection.patch ) # downstream

src_configure() {
	local cal_ft myproducts

	# applications
	for cal_ft in ${CAL_FTS[@]}; do
		use calligra_features_${cal_ft} && myproducts+=( "${cal_ft^^}" )
	done

	use lcms && myproducts+=( PLUGIN_COLORENGINES )
	use okular && myproducts+=( OKULAR )

	local mycmakeargs=(
		-DPACKAGERS_BUILD=OFF
		-DRELEASE_BUILD=ON
		-DWITH_Iconv=ON
		-DWITH_Imath=ON # w/ LCMS: 16 bit floating point Grayscale colorspace
		-DCMAKE_DISABLE_FIND_PACKAGE_Cauchy=ON
		-DPRODUCTSET="${myproducts[*]}"
		$(cmake_use_find_package charts KChart6)
		-DWITH_Fontconfig=$(usex fontconfig)
		-DWITH_GSL=$(usex gsl)
		-DWITH_LibEtonyek=$(usex import-filter)
		-DWITH_LibOdfGen=$(usex import-filter)
		-DWITH_LibRevenge=$(usex import-filter)
		-DWITH_LibVisio=$(usex import-filter)
		-DWITH_LibWpd=$(usex import-filter)
		-DWITH_LibWpg=$(usex import-filter)
		-DWITH_LibWps=$(usex import-filter)
		$(cmake_use_find_package phonon Phonon4Qt6)
		-DWITH_LCMS2=$(usex lcms)
		-DWITH_Okular6=$(usex okular)
		-DWITH_Poppler=$(usex pdf)
		-DWITH_Eigen3=$(usex calligra_features_sheets)
		-DBUILD_UNMAINTAINED=$(usex calligra_features_stage)
		-DWITH_Freetype=$(usex truetype)
		$(cmake_use_find_package webengine Qt6WebEngineWidgets)
	)

	ecm_src_configure
}

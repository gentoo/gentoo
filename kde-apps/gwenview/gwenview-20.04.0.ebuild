# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.69.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Image viewer by KDE"
HOMEPAGE="https://kde.org/applications/graphics/org.kde.gwenview
https://userbase.kde.org/Gwenview"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="activities fits kipi +mpris raw semantic-desktop share X"

# requires running environment
RESTRICT+=" test"

COMMON_DEPEND="
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtopengl-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	media-gfx/exiv2:=
	media-libs/lcms:2
	media-libs/libpng:0=
	media-libs/phonon[qt5(+)]
	virtual/jpeg:0
	activities? ( >=kde-frameworks/kactivities-${KFMIN}:5 )
	fits? ( sci-libs/cfitsio )
	kipi? ( >=kde-apps/libkipi-${PVCUT}:5= )
	mpris? ( >=dev-qt/qtdbus-${QTMIN}:5 )
	raw? ( >=kde-apps/libkdcraw-${PVCUT}:5 )
	semantic-desktop? (
		>=kde-frameworks/baloo-${KFMIN}:5
		>=kde-frameworks/kfilemetadata-${KFMIN}:5
	)
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=dev-qt/qtconcurrent-${QTMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kimageformats-${KFMIN}:5
	>=dev-qt/qtimageformats-${QTMIN}:5
	kipi? ( >=kde-apps/kipi-plugins-${PVCUT}:5 )
"

src_prepare() {
	ecm_src_prepare
	if ! use mpris; then
		# FIXME: upstream a better solution
		sed -e "/set(HAVE_QTDBUS/s/\${Qt5DBus_FOUND}/0/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package fits CFitsio)
		$(cmake_use_find_package kipi KF5Kipi)
		$(cmake_use_find_package raw KF5KDcraw)
		$(cmake_use_find_package share KF5Purpose)
		$(cmake_use_find_package X X11)
	)

	if use semantic-desktop; then
		mycmakeargs+=( -DGWENVIEW_SEMANTICINFO_BACKEND=Baloo )
	else
		mycmakeargs+=( -DGWENVIEW_SEMANTICINFO_BACKEND=None )
	fi

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]] && ! has_version kde-apps/svgpart:${SLOT} ; then
		elog "For SVG support, install kde-apps/svgpart:${SLOT}"
	fi
}

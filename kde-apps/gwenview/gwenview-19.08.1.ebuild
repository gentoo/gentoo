# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
inherit kde5

DESCRIPTION="Image viewer by KDE"
HOMEPAGE="
	https://kde.org/applications/graphics/gwenview/
	https://userbase.kde.org/Gwenview
"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="activities fits kipi +mpris raw semantic-desktop share X"

# requires running environment
RESTRICT+=" test"

COMMON_DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtopengl)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	media-gfx/exiv2:=
	media-libs/lcms:2
	media-libs/libpng:0=
	media-libs/phonon[qt5(+)]
	virtual/jpeg:0
	activities? ( $(add_frameworks_dep kactivities) )
	fits? ( sci-libs/cfitsio )
	kipi? ( $(add_kdeapps_dep libkipi '' '' '5=') )
	mpris? ( $(add_qt_dep qtdbus) )
	raw? ( $(add_kdeapps_dep libkdcraw) )
	semantic-desktop? (
		$(add_frameworks_dep baloo)
		$(add_frameworks_dep kfilemetadata)
	)
	share? ( $(add_frameworks_dep purpose) )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtconcurrent)
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kimageformats)
	$(add_qt_dep qtimageformats)
	kipi? ( $(add_kdeapps_dep kipi-plugins) )
"

src_prepare() {
	kde5_src_prepare
	if ! use mpris; then
		# FIXME: upstream a better solution
		sed -e "/set(HAVE_QTDBUS/s/\${Qt5DBus_FOUND}/0/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package activities KF5Activities)
		$(cmake-utils_use_find_package fits CFitsio)
		$(cmake-utils_use_find_package kipi KF5Kipi)
		$(cmake-utils_use_find_package raw KF5KDcraw)
		$(cmake-utils_use_find_package share KF5Purpose)
		$(cmake-utils_use_find_package X X11)
	)

	if use semantic-desktop; then
		mycmakeargs+=( -DGWENVIEW_SEMANTICINFO_BACKEND=Baloo )
	else
		mycmakeargs+=( -DGWENVIEW_SEMANTICINFO_BACKEND=None )
	fi

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]] && ! has_version kde-apps/svgpart:${SLOT} ; then
		elog "For SVG support, install kde-apps/svgpart:${SLOT}"
	fi
}

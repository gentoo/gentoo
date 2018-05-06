# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	KDE_HANDBOOK="true"
	KDE_TEST="true"
fi
CMAKE_MAKEFILE_GENERATOR="emake"
inherit kde5 toolchain-funcs

DESCRIPTION="Digital photo management application"
HOMEPAGE="https://www.digikam.org/"

LICENSE="GPL-2"
IUSE="addressbook calendar gphoto2 jpeg2k +kipi +lensfun marble mediaplayer semantic-desktop mysql opengl openmp +panorama scanner X"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	KEYWORDS="amd64 x86"
	MY_PV=${PV/_/-}
	MY_P=${PN}-${MY_PV}
	SRC_BRANCH=stable
	[[ ${PV} =~ beta[0-9]$ ]] && SRC_BRANCH=unstable
	SRC_URI="mirror://kde/${SRC_BRANCH}/digikam/${MY_P}.tar.xz"
	S="${WORKDIR}/${MY_P}/core"
fi

COMMON_DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui '-gles2')
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsql 'mysql?')
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/expat
	>=media-gfx/exiv2-0.26:=
	media-libs/lcms:2
	media-libs/liblqr
	media-libs/libpng:0=
	media-libs/opencv:=[-qt4(-)]
	|| ( <media-libs/opencv-3.0.0 >=media-libs/opencv-3.1.0 )
	media-libs/tiff:0
	virtual/jpeg:0
	addressbook? (
		$(add_kdeapps_dep akonadi-contacts)
		$(add_kdeapps_dep kcontacts)
	)
	calendar? ( <kde-apps/kcalcore-17.11.80:5 )
	gphoto2? ( media-libs/libgphoto2:= )
	jpeg2k? ( media-libs/jasper:= )
	kipi? ( $(add_kdeapps_dep libkipi '' '16.03.80') )
	lensfun? ( media-libs/lensfun )
	marble? (
		$(add_frameworks_dep kbookmarks)
		$(add_kdeapps_dep marble)
		$(add_qt_dep qtconcurrent)
		$(add_qt_dep qtnetwork)
	)
	mediaplayer? ( media-libs/qtav[opengl] )
	mysql? ( virtual/mysql[server] )
	opengl? (
		$(add_qt_dep qtopengl)
		virtual/opengl
	)
	panorama? ( $(add_frameworks_dep threadweaver) )
	scanner? ( $(add_kdeapps_dep libksane) )
	semantic-desktop? ( $(add_frameworks_dep kfilemetadata) )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/eigen:3
	dev-libs/boost[threads]
	sys-devel/gettext
	panorama? (
		sys-devel/bison
		sys-devel/flex
	)
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/kipi-plugins:5
	panorama? ( media-gfx/hugin )
	!media-gfx/digikam:4
"

RESTRICT=test
# bug 366505

PATCHES=( "${FILESDIR}/${P}-qt-5.9.3.patch" )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	kde5_pkg_pretend
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	kde5_pkg_setup
}

# FIXME: Unbundle libraw (libs/rawengine/libraw)
src_prepare() {
	if [[ ${KDE_BUILD_TYPE} != live ]]; then
		# prepare the translations
		mv "${WORKDIR}/${MY_P}/po" po || die
		find po -name "*.po" -and -not -name "digikam.po" -delete || die
		echo "set_property(GLOBAL PROPERTY ALLOW_DUPLICATE_CUSTOM_TARGETS 1)" >> CMakeLists.txt || die
		echo "find_package(Gettext REQUIRED)" >> CMakeLists.txt || die
		echo "add_subdirectory( po )" >> CMakeLists.txt || die

		if use handbook; then
			# subdirs need to be preserved b/c relative paths...
			# doc-translated is, in fact, broken, and ignored
			mv "${WORKDIR}/${MY_P}/doc/${PN}" doc-default || die
			echo "find_package(KF5DocTools REQUIRED)" >> CMakeLists.txt || die
			echo "add_subdirectory( doc-default )" >> CMakeLists.txt || die
		fi
	fi

	if ! use marble; then
		punt_bogus_dep Qt5 Network
	fi

	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_APPSTYLES=ON
		-DENABLE_AKONADICONTACTSUPPORT=$(usex addressbook)
		-DENABLE_MEDIAPLAYER=$(usex mediaplayer)
		-DENABLE_MYSQLSUPPORT=$(usex mysql)
		-DENABLE_OPENCV3=$(has_version ">=media-libs/opencv-3" && echo yes || echo no)
		$(cmake-utils_use_find_package calendar KF5CalendarCore)
		$(cmake-utils_use_find_package gphoto2 Gphoto2)
		$(cmake-utils_use_find_package jpeg2k Jasper)
		$(cmake-utils_use_find_package kipi KF5Kipi)
		$(cmake-utils_use_find_package lensfun LensFun)
		$(cmake-utils_use_find_package marble Marble)
		$(cmake-utils_use_find_package mediaplayer QtAV)
		$(cmake-utils_use_find_package opengl OpenGL)
		$(cmake-utils_use_find_package openmp OpenMP)
		$(cmake-utils_use_find_package panorama KF5ThreadWeaver)
		$(cmake-utils_use_find_package scanner KF5Sane)
		$(cmake-utils_use_find_package semantic-desktop KF5FileMetaData)
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}

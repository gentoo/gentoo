# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Non-linear video editing suite by KDE"
HOMEPAGE="https://www.kdenlive.org/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="freesound gles2 semantic-desktop share v4l"

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui 'gles2=')
	$(add_qt_dep qtmultimedia)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-cpp/rttr
	>=media-libs/mlt-6.16.0[ffmpeg,frei0r,kdenlive,melt,qt5,sdl,xml]
	freesound? ( >=dev-qt/qtwebkit-5.212.0_pre20180120:5 )
	semantic-desktop? ( $(add_frameworks_dep kfilemetadata) )
	share? ( $(add_frameworks_dep purpose) )
	v4l? ( media-libs/libv4l )
"
RDEPEND="${DEPEND}
	$(add_qt_dep qtquickcontrols)
	virtual/ffmpeg[encode,sdl,X]
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package freesound Qt5WebKitWidgets)
		$(cmake-utils_use_find_package semantic-desktop KF5FileMetaData)
		$(cmake-utils_use_find_package share KF5Purpose)
		$(cmake-utils_use_find_package v4l LibV4L2)
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	# Gentoo bug 603168
	if ! has_version "media-libs/mlt[fftw]" ; then
		elog "For 'Crop and Transform/Rotate and Shear' effect, please build media-libs/mlt with USE=fftw enabled."
	fi
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=5.70.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Non-linear video editing suite by KDE"
HOMEPAGE="https://kdenlive.org/en/"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="freesound gles2-only semantic-desktop share v4l"

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	dev-cpp/rttr
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[gles2-only=]
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=media-libs/mlt-6.20.0[ffmpeg,frei0r,kdenlive,melt,qt5,sdl,xml]
	freesound? ( >=dev-qt/qtwebkit-5.212.0_pre20180120:5 )
	semantic-desktop? ( >=kde-frameworks/kfilemetadata-${KFMIN}:5 )
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
	v4l? ( media-libs/libv4l )
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	media-video/ffmpeg[encode,sdl,X]
"

RESTRICT+=" test" # segfaults, bug 684132

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package freesound Qt5WebKitWidgets)
		$(cmake_use_find_package semantic-desktop KF5FileMetaData)
		$(cmake_use_find_package share KF5Purpose)
		$(cmake_use_find_package v4l LibV4L2)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	# Gentoo bug 603168
	if ! has_version "media-libs/mlt[fftw]" ; then
		elog "For 'Crop and Transform/Rotate and Shear' effect, please build media-libs/mlt with USE=fftw enabled."
	fi
}

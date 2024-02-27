# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_HANDBOOK="optional"
ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org optfeature

DESCRIPTION="Non-linear video editing suite by KDE"
HOMEPAGE="https://kdenlive.org/en/"

LICENSE="GPL-3"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="gles2-only semantic-desktop v4l"

RESTRICT="test" # segfaults, bug 684132

DEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5[gles2-only=]
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtnetworkauth-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kfilemetadata-${KFMIN}:5
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
	>=kde-frameworks/purpose-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=media-libs/mlt-7.14.0[ffmpeg,frei0r,qt5,sdl,xml]
	v4l? ( media-libs/libv4l )
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	media-video/ffmpeg[encode,libass,sdl,X]
	media-video/mediainfo
"
BDEPEND="sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package v4l LibV4L2)
	)
	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst
	optfeature "VP8 and VP9 codec support" "media-video/ffmpeg[vpx]"
}

# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Convergent podcast application for desktop and mobile"
HOMEPAGE="https://apps.kde.org/kasts/"

LICENSE="GPL-2 GPL-2+ GPL-3+ BSD LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE="gstreamer networkmanager vlc"

DEPEND="
	>=dev-libs/kirigami-addons-0.7.2:5
	dev-libs/qtkeychain:=[qt5(+)]
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/syndication-${KFMIN}:5
	>=kde-frameworks/threadweaver-${KFMIN}:5
	media-libs/taglib
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-good:1.0
	)
	networkmanager? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:5 )
	vlc? ( media-video/vlc:= )
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
"
BDEPEND="gstreamer? ( virtual/pkgconfig )"

src_prepare() {
	ecm_src_prepare
	ecm_punt_qt_module Test
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLE_PLAYER=OFF
		-DBUILD_GSTREAMER_BACKEND=$(usex gstreamer)
		$(cmake_use_find_package networkmanager NetworkManagerQt)
		$(cmake_use_find_package vlc NetworkManagerQt)
	)
	ecm_src_configure
}

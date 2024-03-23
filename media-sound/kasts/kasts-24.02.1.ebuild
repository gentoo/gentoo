# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Convergent podcast application for desktop and mobile"
HOMEPAGE="https://apps.kde.org/kasts/"

LICENSE="GPL-2 GPL-2+ GPL-3+ BSD LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gstreamer networkmanager vlc"

DEPEND="
	dev-libs/kirigami-addons:6
	>=dev-libs/qtkeychain-0.14.1-r1:=[qt6]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,sql,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/syndication-${KFMIN}:6
	>=kde-frameworks/threadweaver-${KFMIN}:6
	media-libs/taglib:=
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-good:1.0
	)
	networkmanager? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:6 )
	vlc? ( media-video/vlc:= )
"
RDEPEND="${DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
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
		$(cmake_use_find_package networkmanager KF6NetworkManagerQt)
		$(cmake_use_find_package vlc LIBVLC)
	)
	ecm_src_configure
}

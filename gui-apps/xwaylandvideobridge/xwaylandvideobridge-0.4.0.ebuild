# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.245.0
QTMIN=6.6.2
KDE_ORG_CATEGORY="system"
inherit ecm kde.org

DESCRIPTION="Screenshare Wayland windows to XWayland apps"
HOMEPAGE="https://planet.kde.org/david-edmundson-2023-03-22-fixing-wayland-xwayland-screen-casting/
https://invent.kde.org/system/xwaylandvideobridge"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	kde-plasma/kpipewire:6
	media-libs/freetype
	x11-libs/libxcb:=
	x11-libs/xcb-util
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

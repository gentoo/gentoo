# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=b7d6dd1f56380db2d37e4035951653567f10a12d
KFMIN=6.9.0
QTMIN=6.8.1
KDE_ORG_CATEGORY="system"
inherit ecm kde.org xdg

DESCRIPTION="Screenshare Wayland windows to XWayland apps"
HOMEPAGE="https://planet.kde.org/david-edmundson-2023-03-22-fixing-wayland-xwayland-screen-casting/
https://invent.kde.org/system/xwaylandvideobridge"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/kde/${P}-${COMMIT:0:8}.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,X]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	kde-plasma/kpipewire:6
	media-libs/freetype
	x11-libs/libxcb:=
	x11-libs/xcb-util
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-qt-6.10.patch" ) # bug #966307

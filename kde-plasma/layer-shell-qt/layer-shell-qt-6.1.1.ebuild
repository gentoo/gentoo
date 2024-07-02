# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.3.0
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Qt component to allow applications make use of Wayland wl-layer-shell protocol"

LICENSE="LGPL-3+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

# slot op: various private QtWaylandClient headers
RDEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtwayland-${QTMIN}:6=
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

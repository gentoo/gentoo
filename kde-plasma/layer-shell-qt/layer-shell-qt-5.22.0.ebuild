# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.82.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Qt component to allow applications make use of Wayland wl-layer-shell protocol"

LICENSE="LGPL-3+"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[X]
	>=dev-qt/qtwayland-${QTMIN}:5
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}
	>=dev-libs/plasma-wayland-protocols-1.1.1
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

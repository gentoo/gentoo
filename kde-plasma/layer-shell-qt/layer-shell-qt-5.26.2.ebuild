# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.99.0
QTMIN=5.15.5
inherit ecm plasma.kde.org

DESCRIPTION="Qt component to allow applications make use of Wayland wl-layer-shell protocol"

LICENSE="LGPL-3+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
IUSE=""

# dev-qt/qtgui: QtXkbCommonSupport is provided by either IUSE libinput or X
# slot op: various private QtWaylandClient headers
RDEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtdeclarative-${QTMIN}:5
	|| (
		>=dev-qt/qtgui-${QTMIN}:5[libinput]
		>=dev-qt/qtgui-${QTMIN}:5[X]
	)
	>=dev-qt/qtwayland-${QTMIN}:5=
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	dev-util/wayland-scanner
	virtual/pkgconfig
"

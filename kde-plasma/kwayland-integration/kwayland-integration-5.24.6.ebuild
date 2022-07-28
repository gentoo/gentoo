# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.92.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.4
inherit ecm plasma.kde.org

DESCRIPTION="Provides integration plugins for various KDE frameworks for Wayland"
HOMEPAGE="https://invent.kde.org/plasma/kwayland-integration"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RESTRICT="test" # bug 668872

# dev-qt/qtgui: QtXkbCommonSupport is provided by either IUSE libinput or X
# slot ops:
# dev-qt/qtwayland: Qt::WaylandClientPrivate (private/qwayland*_p.h) stuff
# kde-frameworks/kidletime: KIdleTime/private/abstractsystempoller.h
# kde-frameworks/kwindowsystem: Various private headers
DEPEND="
	>=dev-libs/wayland-1.15
	|| (
		>=dev-qt/qtgui-${QTMIN}:5[libinput]
		>=dev-qt/qtgui-${QTMIN}:5[X]
	)
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5=
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5=
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5=
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	virtual/pkgconfig
"

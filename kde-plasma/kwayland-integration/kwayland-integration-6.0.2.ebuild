# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.115.0
QTMIN=5.15.12
inherit ecm flag-o-matic plasma.kde.org

DESCRIPTION="Provides KWindowSystem integration plugin for Wayland"
HOMEPAGE="https://invent.kde.org/plasma/kwayland-integration"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

# dev-qt/qtgui: QtXkbCommonSupport is provided by either IUSE libinput or X
# slot ops:
# dev-qt/qtgui: QtXkbCommonSupportPrivate
# dev-qt/qtwayland: Qt::WaylandClientPrivate (private/qwayland*_p.h) stuff
# kde-frameworks/kwindowsystem: Various private headers
RDEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtgui-${QTMIN}:5=
	|| (
		>=dev-qt/qtgui-${QTMIN}:5[libinput]
		>=dev-qt/qtgui-${QTMIN}:5[X]
	)
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5=
	>=kde-frameworks/kwindowsystem-${KFMIN}:5=
	>=kde-plasma/kwayland-${KFMIN}:5
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}
	dev-libs/plasma-wayland-protocols
"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	filter-lto # bug 921430
	ecm_src_configure
}

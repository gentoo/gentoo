# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.99.0
QTMIN=5.15.5
inherit ecm plasma.kde.org

DESCRIPTION="Provides KWindowSystem integration plugin for Wayland"
HOMEPAGE="https://invent.kde.org/plasma/kwayland-integration"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv"
IUSE=""

# dev-qt/qtgui: QtXkbCommonSupport is provided by either IUSE libinput or X
# slot ops:
# dev-qt/qtgui: QtXkbCommonSupportPrivate
# dev-qt/qtwayland: Qt::WaylandClientPrivate (private/qwayland*_p.h) stuff
# kde-frameworks/kwindowsystem: Various private headers
DEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtgui-${QTMIN}:5=
	|| (
		>=dev-qt/qtgui-${QTMIN}:5[libinput]
		>=dev-qt/qtgui-${QTMIN}:5[X]
	)
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5=
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5=
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	virtual/pkgconfig
"

src_prepare() {
	ecm_src_prepare
	ecm_punt_kf_module IdleTime
	cmake_comment_add_subdirectory autotests # only contains idletime test
	cmake_run_in src cmake_comment_add_subdirectory idletime
}

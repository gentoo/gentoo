# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="forceoptional"
KFMIN=5.95.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm plasma.kde.org

DESCRIPTION="Plasma screen management library"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5/7"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

# requires running session
RESTRICT="test"

RDEPEND="
	dev-libs/wayland
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	x11-libs/libxcb
"
DEPEND="${RDEPEND}
	>=dev-libs/plasma-wayland-protocols-1.6.0
"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	dev-util/wayland-scanner
"

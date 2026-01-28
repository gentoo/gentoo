# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="forceoptional"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm plasma.kde.org toolchain-funcs

DESCRIPTION="Plasma screen management library"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6/8"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# requires running session
RESTRICT="test"

# slot op: Uses Qt::GuiPrivate for qtx11extras_p.h
RDEPEND="
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,wayland]
	>=kde-frameworks/kconfig-${KFMIN}:6
	x11-libs/libxcb:=
"
DEPEND="${RDEPEND}
	>=dev-libs/plasma-wayland-protocols-1.19.0
"
BDEPEND="
	>=dev-qt/qttools-${QTMIN}:6[linguist]
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
"

PATCHES=( "${FILESDIR}/${P}-kwayland-crashfix.patch" ) # KDE-bug #511757

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-min_ver gcc 13.4
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-min_ver gcc 13.4
}

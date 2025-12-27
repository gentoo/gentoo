# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt GUI Screenshot Utility"
HOMEPAGE="https://lxqt.github.io/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2 GPL-2+ LGPL-2.1+"
SLOT="0"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.3.0
"
DEPEND="
	>=dev-libs/libqtxdg-4.3.0
	dev-libs/wayland
	>=dev-qt/qtbase-6.6:6[dbus,gui,network,widgets]
	>=dev-qt/qtwayland-6.6:6
	kde-frameworks/kwindowsystem:6[X]
	kde-plasma/layer-shell-qt:6
	x11-libs/libX11
	x11-libs/libxcb:=
"
RDEPEND="${DEPEND}"

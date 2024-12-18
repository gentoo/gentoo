# Copyright 1999-2024 Gentoo Authors
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
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2 GPL-2+ LGPL-2.1+"
SLOT="0"

BDEPEND=">=dev-qt/qttools-6.6:6[linguist]"
DEPEND="
	>=dev-libs/libqtxdg-4.1.0
	>=dev-qt/qtbase-6.6:6[dbus,gui,network,widgets]
	kde-frameworks/kwindowsystem:6[X]
	x11-libs/libX11
	x11-libs/libxcb:=
"
RDEPEND="${DEPEND}"

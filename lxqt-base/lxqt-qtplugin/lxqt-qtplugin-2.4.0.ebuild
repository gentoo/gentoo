# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="LXQt system integration plugin for Qt"
HOMEPAGE="
	https://lxqt-project.org/
	https://github.com/lxqt/lxqt-qtplugin/
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.4.0
"
DEPEND="
	>=dev-libs/libdbusmenu-lxqt-0.4.0
	>=dev-libs/libqtxdg-4.4.0
	>=dev-qt/qtbase-6.6:6=[dbus,gui,widgets]
	=x11-libs/libfm-qt-${MY_PV}*
"
RDEPEND="${DEPEND}"

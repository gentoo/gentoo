# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

MY_P=KDocker-${PV}
DESCRIPTION="Helper to dock any application into the system tray"
HOMEPAGE="https://github.com/user-none/KDocker"
SRC_URI="https://github.com/user-none/KDocker/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-qt/qtbase:6[dbus,gui,widgets,X]
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	x11-libs/libxcb
"

PATCHES=(
	# Merged. To be removed at next version 6.3.
	"${FILESDIR}"/${P}-fix_clang.patch
)

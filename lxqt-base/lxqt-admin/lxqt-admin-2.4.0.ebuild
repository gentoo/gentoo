# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="LXQt system administration tool"
HOMEPAGE="
	https://lxqt-project.org/
	https://github.com/lxqt/lxqt-admin/
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

BDEPEND=">=dev-util/lxqt-build-tools-2.4.0"
DEPEND="
	>=dev-qt/qtbase-6.6:6[dbus,gui,widgets]
	=lxqt-base/liblxqt-${MY_PV}*
	kde-frameworks/kwindowsystem:6
	>=sys-auth/polkit-qt-0.200.0-r1
	=lxqt-base/liblxqt-${MY_PV}*:=
"
RDEPEND="${DEPEND}"

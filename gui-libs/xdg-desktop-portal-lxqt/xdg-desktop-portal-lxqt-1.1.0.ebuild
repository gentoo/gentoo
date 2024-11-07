# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Backend implementation for xdg-desktop-portal using Qt/KF5/libfm-qt"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND=">=dev-util/lxqt-build-tools-2.1.0"
DEPEND="
	>=dev-qt/qtbase-6.6:6[dbus,gui,widgets]
	kde-frameworks/kwindowsystem:6
	>=x11-libs/libfm-qt-2.1:=
"
RDEPEND="${DEPEND}
	sys-apps/xdg-desktop-portal
"

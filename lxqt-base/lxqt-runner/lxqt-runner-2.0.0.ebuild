# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="LXQt quick launcher"
HOMEPAGE="https://lxqt-project.org/"

MY_PV="$(ver_cut 1-2)"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="LGPL-2.1 LGPL-2.1+"
SLOT="0"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.0.0
	virtual/pkgconfig
"
DEPEND="
	>=dev-cpp/muParser-2.2.3
	>=dev-libs/libqtxdg-4.0.0
	>=dev-qt/qtbase-6.6:6[dbus,gui,widgets,xml]
	kde-frameworks/kwindowsystem:6
	>=kde-plasma/layer-shell-qt-6.0:6
	=lxqt-base/liblxqt-${MY_PV}*:=
	=lxqt-base/lxqt-globalkeys-${MY_PV}*
"
RDEPEND="${DEPEND}"

src_install() {
	cmake_src_install
	doman man/*.1
}

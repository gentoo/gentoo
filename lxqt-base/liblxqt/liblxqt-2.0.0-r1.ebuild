# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Common base library for the LXQt desktop environment"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="LGPL-2.1+ BSD"
SLOT="0/$(ver_cut 1-2)"
IUSE="+backlight"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.0.0
"
DEPEND="
	>=dev-libs/libqtxdg-4.0.0
	>=dev-qt/qtbase-6.6:6[dbus,gui,widgets,xml]
	kde-frameworks/kwindowsystem:6[X]
	x11-libs/libX11
	x11-libs/libXScrnSaver
	backlight? ( >=sys-auth/polkit-qt-0.200.0[qt6] )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_BACKLIGHT_LINUX_BACKEND=$(usex backlight)
	)

	cmake_src_configure
}

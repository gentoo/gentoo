# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake xdg

DESCRIPTION="Lightweight Qt5 Plain-Text Editor for Linux"
HOMEPAGE="https://github.com/tsujan/FeatherPad"
EGIT_REPO_URI="https://github.com/tsujan/FeatherPad"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+X"

RDEPEND="
	app-text/hunspell:=
	dev-qt/qtbase:6[dbus,gui,widgets]
	dev-qt/qtsvg:6
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_X11=$(usex !X)
	)
	cmake_src_configure
}

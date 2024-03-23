# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Lightweight Qt5 Plain-Text Editor for Linux"
HOMEPAGE="https://github.com/tsujan/FeatherPad"
SRC_URI="https://github.com/tsujan/FeatherPad/archive/V${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FeatherPad-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+X"

RDEPEND="
	app-text/hunspell:=
	dev-qt/qtbase:6[cups,dbus,gui,widgets]
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

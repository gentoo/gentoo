# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION=" Lightweight Qt Notes-Manager for Linux"
HOMEPAGE="https://github.com/tsujan/FeatherNotes"
SRC_URI="https://github.com/tsujan/FeatherNotes/archive/V${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FeatherNotes-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="spell X"

RDEPEND="
	dev-qt/qtbase:6[dbus,gui,network,widgets,xml,X?]
	dev-qt/qtsvg:6
	spell? ( app-text/hunspell:= )
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_X11=$(usex !X)
		-DWITH_HUNSPELL=$(usex spell)
	)
	cmake_src_configure
}

# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Lightweight Qt5 Plain-Text Editor for Linux"
HOMEPAGE="https://github.com/tsujan/FeatherPad"
SRC_URI="https://github.com/tsujan/FeatherPad/archive/V${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FeatherPad-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="qt6 +X"

RDEPEND="
	app-text/hunspell:=
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		X? ( dev-qt/qtx11extras:5 )
	)
	qt6? (
		dev-qt/qtbase:6[cups,dbus,gui,widgets]
		dev-qt/qtsvg:6
	)
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	!qt6? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_X11=$(usex !X)
		-DENABLE_QT5=$(usex !qt6)
	)
	cmake_src_configure
}

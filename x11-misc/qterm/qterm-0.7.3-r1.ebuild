# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="A BBS client based on Qt"
HOMEPAGE="https://github.com/qterm/qterm"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5[scripttools]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	x11-libs/libX11
	dev-libs/openssl:="
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="dev-qt/linguist-tools:5
	dev-qt/qthelp:5
	x11-base/xorg-proto"

DOCS=( README.rst RELEASE_NOTES TODO doc/script.txt )

src_prepare() {
	# file collision with sys-cluster/torque, bug #176533
	sed -i "/PROGRAME /s/qterm/QTerm/" CMakeLists.txt || die
	sed -i "s/Exec=qterm/Exec=QTerm/" src/${PN}.desktop || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQT5=ON
	)

	cmake_src_configure
}

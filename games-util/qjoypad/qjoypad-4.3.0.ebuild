# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop

DESCRIPTION="Translate gamepad/joystick input into key strokes/mouse actions in X"
HOMEPAGE="https://github.com/panzi/qjoypad"
SRC_URI="https://github.com/panzi/qjoypad/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	virtual/libudev
	x11-libs/libxcb
	x11-libs/libXtst
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	x11-base/xorg-proto
"

src_install() {
	cmake-utils_src_install

	local i
	cd icons || die
	for i in *.png; do
		newicon ${i} ${i/gamepad/qjoypad}
	done
	make_desktop_entry ${PN} QJoypad ${PN}
}

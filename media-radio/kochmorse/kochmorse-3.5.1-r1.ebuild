# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Morse-code tutor using the Koch method"
HOMEPAGE="https://github.com/hmatuschek/kochmorse"
SRC_URI="https://github.com/hmatuschek/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="dev-qt/linguist-tools:5"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s/2.8.8/3.5.1/g" CMakeLists.txt ||die
	eapply_user
	cmake_src_prepare
}

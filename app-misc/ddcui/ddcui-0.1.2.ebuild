# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

DESCRIPTION="Graphical user interface for ddcutil - control monitor settings"
HOMEPAGE="https://www.ddcutil.com/ddcui_main/"
SRC_URI="https://github.com/rockowitz/ddcui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	dev-libs/glib
	>=app-misc/ddcutil-0.9.9
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	virtual/freedesktop-icon-theme
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	# move docs to correct dir
	sed -i -e "s%share/doc/ddcui%share/doc/${PF}%g" CMakeLists.txt || die
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	make_desktop_entry ddcui "Monitor Settings" preferences-desktop-display Settings
}

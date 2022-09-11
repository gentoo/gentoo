# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check for bumps & cleanup with app-misc/ddcutil

inherit cmake xdg

DESCRIPTION="Graphical user interface for ddcutil - control monitor settings"
HOMEPAGE="https://www.ddcutil.com/ddcui_main/"
SRC_URI="https://github.com/rockowitz/ddcui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	dev-libs/glib
	>=app-misc/ddcutil-1.3.0:0/4
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	# move docs to correct dir
	sed -i -e "s%share/doc/ddcui%share/doc/${PF}%g" CMakeLists.txt || die
	cmake_src_prepare
}

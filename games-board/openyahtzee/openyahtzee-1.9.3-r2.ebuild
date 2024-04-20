# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit flag-o-matic wxwidgets

DESCRIPTION="Full-featured wxWidgets version of the classic dice game Yahtzee"
HOMEPAGE="https://openyahtzee.sourceforge.net/"
SRC_URI="mirror://sourceforge/openyahtzee/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"

PATCHES=( "${FILESDIR}"/${P}-wx32.patch )

src_configure() {
	append-cxxflags -std=c++11
	setup-wxwidgets
	econf --datadir=/usr/share
}

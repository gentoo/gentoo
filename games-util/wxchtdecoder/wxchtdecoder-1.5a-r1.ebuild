# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit wxwidgets

DESCRIPTION="A program to decode .CHT files in Snes9x and ZSNES to plain text"
HOMEPAGE="http://games.technoplaza.net/chtdecoder/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND=${RDEPEND}

PATCHES=( "${FILESDIR}"/${P}-wxgtk.patch )

src_configure() {
	setup-wxwidgets
	econf --with-wx-config="${WX_CONFIG}"
}

src_install() {
	dobin source/wxchtdecoder
	dodoc docs/wxchtdecoder.txt
}

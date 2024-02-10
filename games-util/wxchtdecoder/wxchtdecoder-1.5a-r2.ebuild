# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit desktop wxwidgets

DESCRIPTION="Program to decode .CHT files in Snes9x and ZSNES to plain text"
HOMEPAGE="https://games.technoplaza.net/chtdecoder/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
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
	make_desktop_entry ${PN} wxCHTDecoder application-vnd.nintendo.snes.rom
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop flag-o-matic

DESCRIPTION="Very polished Tetris clone"
HOMEPAGE="http://lgames.sourceforge.net/LTris/"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-mixer
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-gentoo.patch
	mv configure.in configure.ac || die
	AT_M4DIR=m4 eautoreconf
	append-cflags -std=gnu89 # build with gcc5 (bug #570966)
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	newicon icons/ltris48.xpm ${PN}.xpm
	make_desktop_entry ltris LTris
}

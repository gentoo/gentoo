# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools flag-o-matic eutils games

DESCRIPTION="very polished Tetris clone"
HOMEPAGE="http://lgames.sourceforge.net/index.php?project=LTris"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	mv configure.in configure.ac || die
	AT_M4DIR=m4 eautoreconf
	append-cflags -std=gnu89 # build with gcc5 (bug #570966)
}

src_configure() {
	egamesconf $(use_enable nls)
}

src_install() {
	default
	newicon icons/ltris48.xpm ${PN}.xpm
	make_desktop_entry ltris LTris
	prepgamesdirs
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Japanese version of chess (commandline + X-Version)"
HOMEPAGE="https://www.gnu.org/software/gnushogi/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"

RDEPEND="sys-libs/ncurses
	X? ( x11-libs/libXaw )"
DEPEND="${RDEPEND}
	>=sys-devel/bison-1.34
	>=sys-devel/flex-2.5"

src_prepare() {
	sed -i \
		-e '/^bbk:/s/$/ gnushogi_compile pat2inc sizetest/' \
		Makefile.in || die
	sed -i \
		-e "/^LIBDIR/s:=.*:=\"$(games_get_libdir)\":" \
		gnushogi/Makefile.in || die
}

src_configure() {
	egamesconf \
		$(use_with X x) \
		$(use_enable X xshogi)
}

src_install() {
	dogamesbin gnushogi/gnushogi
	doman doc/gnushogi.6
	doinfo doc/gnushogi.info
	if use X ; then
		dogamesbin xshogi/xshogi
		doman doc/xshogi.6
		make_desktop_entry xshogi XShogi
	fi
	dogameslib gnushogi/gnushogi.bbk
	dodoc README NEWS CONTRIB
	dohtml doc/gnushogi/*.html
	prepgamesdirs
}

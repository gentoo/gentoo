# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/typespeed/typespeed-0.6.5.ebuild,v 1.7 2015/02/06 21:56:18 tupone Exp $

EAPI=5
inherit autotools games

DESCRIPTION="Test your typing speed, and get your fingers CPS"
HOMEPAGE="http://typespeed.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc64 x86"
IUSE="nls"

RDEPEND="sys-libs/ncurses
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e 's/testsuite//' \
		-e 's/doc//' \
		Makefile.am \
		|| die
	sed -i \
		-e '/^CC =/d' \
		src/Makefile.am \
		|| die
	rm -rf m4 #417265
	eautoreconf
}

src_configure() {
	egamesconf \
		--localedir=/usr/share/locale \
		--docdir=/usr/share/doc/${PF} \
		--with-highscoredir="${GAMES_STATEDIR}" \
		$(use_enable nls)
}

src_install() {
	default
	dodoc doc/README
	prepgamesdirs
}

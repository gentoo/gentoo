# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/mah-jong/mah-jong-1.14.ebuild,v 1.4 2014/10/18 14:15:37 ago Exp $

EAPI=5
inherit eutils toolchain-funcs games

MY_P="mj-${PV}-src"
DESCRIPTION="A networked Mah Jong program, together with a computer player"
HOMEPAGE="http://www.stevens-bradfield.com/MahJong/"
SRC_URI="http://mahjong.julianbradfield.org/Source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-lang/perl"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e '/^.TH/ s/1/6/' xmj.man || die
	sed -i \
		-e "/^DESTDIR =/ s:=.*:= ${D}:" \
		-e "/^BINDIR =/ s:=.*:= ${GAMES_BINDIR}:" \
		-e '/^MANDIR =/ s:man/man1:/usr/share/man/man6:' \
		-e '/^MANSUFFIX =/ s:1:6:' \
		-e "/^CC =/ s:gcc:$(tc-getCC):" \
		-e "/^CFLAGS =/ s:=:= ${CFLAGS}:" \
		-e "/^LDLIBS =/ s:$:${LDFLAGS}:" \
		-e '/^INSTPGMFLAGS =/ s:-s::' \
		-e '/^CDEBUGFLAGS =/d' \
		-e "/^TILESETPATH=/ s:NULL:\"${GAMES_DATADIR}/${PN}/\":" Makefile || die
}

src_install() {
	emake install install.man
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r fallbacktiles/ tiles-numbered/ tiles-small/
	newicon tiles-v1/tongE.xpm ${PN}.xpm
	make_desktop_entry xmj Mah-Jong ${PN}
	dodoc CHANGES ChangeLog *.txt
	prepgamesdirs
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A multi-player 2D client/server space game"
HOMEPAGE="http://www.xpilot.org/"
SRC_URI="mirror://sourceforge/xpilotgame/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
	x11-misc/gccmakedep
	x11-misc/imake
	app-text/rman"

src_prepare() {
	sed -i \
		-e '/^INSTMAN/s:=.*:=/usr/share/man/man6:' \
		-e "/^INSTLIB/s:=.*:=${GAMES_DATADIR}/${PN}:" \
		-e "/^INSTBIN/s:=.*:=${GAMES_BINDIR}:" \
		Local.config || die
	# work with glibc-2.20
	sed -i \
		-e 's/getline/lgetline/' \
		src/client/textinterface.c || die
}

src_compile() {
	xmkmf || die
	emake Makefiles
	emake includes
	emake depend
	emake CC="${CC}" CDEBUGFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	emake DESTDIR="${D}" install.man
	newicon lib/textures/logo.ppm ${PN}.ppm
	make_desktop_entry ${PN} XPilot /usr/share/pixmaps/${PN}.ppm
	dodoc README.txt doc/{ChangeLog,CREDITS,FAQ,README*,TODO}
	prepgamesdirs
}

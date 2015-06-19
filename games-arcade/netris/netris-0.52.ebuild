# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/netris/netris-0.52.ebuild,v 1.17 2015/01/05 15:27:58 tupone Exp $

EAPI=5
inherit eutils games

DEB_VER=7
DESCRIPTION='Classic networked version of T*tris'
HOMEPAGE='http://www.netris.org/'
SRC_URI="ftp://ftp.netris.org/pub/netris/${P}.tar.gz
	mirror://debian/pool/main/n/netris/netris_${PV}-${DEB_VER}.diff.gz"

LICENSE='GPL-2'
SLOT='0'
KEYWORDS='amd64 ~mips ppc ~sparc x86 ~x86-fbsd'
IUSE=''

DEPEND='sys-libs/ncurses'
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${WORKDIR}"/netris_${PV}-${DEB_VER}.diff
	# bug #185332
	sed -i \
		-e '/sys\/time/ i\
#include <sys/types.h> \
#include <time.h>
' \
		-e '/netint2/ s/short/int16_t/' \
		-e '/netint4/ s/long/int32_t/' \
		netris.h \
		|| die 'sed failed'
	sed -i \
		-e '/curses\.h/ a\
#include <term.h>
' \
		curses.c \
		|| die 'sed failed'
	sed -i \
		-e 's/volatile //g' \
		-e '/Be more forgiving/d' \
		-e 's/static myRandSeed/static int myRandSeed/' \
		util.c \
		|| die 'sed failed'
	sed -i \
		-e 's/\(long pauseTimeLeft\)/\1 = 0/' \
		game.c \
		|| die 'sed failed'
	sed -i \
		-e '/^CC/d' \
		-e '/^COPT/d' \
		-e '/^CFLAGS/d' \
		-e 's/(LFLAGS)/(LDFLAGS) $(LFLAGS)/' \
		Configure \
		|| die 'sed failed'
}

src_configure() {
	bash ./Configure -O || die 'Configure failed'
}

src_install() {
	dogamesbin netris sr
	dodoc FAQ README robot_desc
	prepgamesdirs
}

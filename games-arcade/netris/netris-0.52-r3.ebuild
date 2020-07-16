# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DEB_VER="10"
DESCRIPTION="Classic networked version of T*tris"
HOMEPAGE="http://www.netris.org/"
SRC_URI="ftp://ftp.netris.org/pub/netris/${P}.tar.gz
	mirror://debian/pool/main/n/netris/netris_${PV}-${DEB_VER}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE=""

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

src_prepare() {
	default

	tc-export CC CXX LD AR RANLIB

	eapply "${S}"/../debian/patches/[01]*
	eapply "${FILESDIR}"/${P}-tinfo.patch

	# bug #185332
	sed -i \
		-e '/sys\/time/ i\
#include <sys/types.h> \
#include <time.h>
' \
		-e '/netint2/ s/short/int16_t/' \
		-e '/netint4/ s/long/int32_t/' \
		netris.h || die
	sed -i \
		-e 's/volatile //g' \
		-e '/Be more forgiving/d' \
		-e 's/static myRandSeed/static int myRandSeed/' \
		util.c || die
	sed -i \
		-e 's/\(long pauseTimeLeft\)/\1 = 0/' \
		game.c || die
	sed -i \
		-e '/^CC/d' \
		-e '/^COPT/d' \
		-e '/^CFLAGS/d' \
		-e 's/(LFLAGS)/(LDFLAGS) $(LFLAGS)/' \
		Configure || die
}

src_configure() {
	bash ./Configure -O || die
}

src_install() {
	dobin netris
	newbin sr netris-sample-robot
	dodoc FAQ README robot_desc
}

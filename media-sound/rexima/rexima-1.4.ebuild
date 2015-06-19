# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rexima/rexima-1.4.ebuild,v 1.17 2014/08/10 21:11:03 slyfox Exp $

inherit toolchain-funcs

DESCRIPTION="A curses-based interactive mixer which can also be used from the command-line"
HOMEPAGE="http://www.svgalib.org/rus/rexima.html"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/apps/sound/mixers/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC
	echo "LDLIBS=-lncurses" > Makefile
	echo "all: rexima" >> Makefile
	emake || die "emake failed"
}

src_install () {
	dobin rexima || die
	doman rexima.1 || die
	dodoc NEWS README ChangeLog
}

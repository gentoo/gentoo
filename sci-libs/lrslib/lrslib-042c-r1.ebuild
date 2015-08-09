# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit toolchain-funcs

DESCRIPTION="self-contained ANSI C implementation of the reverse search algorithm"
HOMEPAGE="http://cgm.cs.mcgill.ca/~avis/C/lrs.html"
SRC_URI="http://cgm.cs.mcgill.ca/~avis/C/lrslib/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gmp"

DEPEND="gmp? ( dev-libs/gmp )"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -i "s/gcc/$(tc-getCC)/g" makefile || die
	sed -i "s/-O3/${CFLAGS} ${LDFLAGS}/g" makefile || die
}

src_compile () {
	if use amd64 ; then
		emake all64 || die "make failed"
	else
		emake || die "make failed"
	fi
	if use gmp ; then
		emake gmp || die "make failed"
	fi
}

src_install() {
	dobin lrs redund redund1 || die
	# Collides with sys-block/buffer
	newbin buffer lrsbuffer || die
	if use x86; then
		dobin nash setupnash setupnash2 2nash || die
		# Prevent clash with cddlib:
		newbin fourier lrsfourier || die
	fi
	if use gmp; then
		dobin glrs gredund gfourier || die
		# Clash with www-plugins/gnash
		newbin gnash lrsgnash || die
	fi
	dodoc readme || die
	dohtml lrslib.html || die
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

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
	# We don't like static linking to gmp or anywhere.
	if use amd64 ; then
		# This macro may only change messages that the
		# binary outputs, but just in case... (Bug 384195)
		sed -i "s/-static/-DB64/g" makefile || die
	else
		sed -i "s/-static//g" makefile || die
	fi
}

src_compile () {
	if use amd64 ; then
		emake all64
	else
		emake
	fi
	if use gmp ; then
		emake gmp
	fi
}

src_install() {
	dobin lrs redund redund1
	# Collides with sys-block/buffer
	newbin buffer lrsbuffer
	if use x86; then
		dobin nash setupnash setupnash2 2nash
		# Prevent clash with cddlib:
		newbin fourier lrsfourier
	fi
	if use gmp; then
		dobin glrs gredund gfourier
		# Clash with www-plugins/gnash
		newbin gnash lrsgnash
	fi
	dodoc readme
	dohtml lrslib.html
}

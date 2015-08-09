# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="self-contained ANSI C implementation of the reverse search algorithm"
HOMEPAGE="http://cgm.cs.mcgill.ca/~avis/C/lrs.html"
SRC_URI="http://cgm.cs.mcgill.ca/~avis/C/lrslib/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gmp"

DEPEND="gmp? ( dev-libs/gmp )"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -i "s/gcc/$(tc-getCC)/g" makefile || die
	sed -i "s/-O3/${CFLAGS} ${LDFLAGS}/g" makefile || die
	# Prefix for install
	sed -i "s,/usr/local,/usr,g" makefile || die
}

src_compile () {
	if use gmp ; then
		emake all
		emake all-shared
	else
		emake allmp
	fi
}

src_install() {
	dodoc readme
	# Library
	if use gmp ; then
		emake DESTDIR="${D}" install-shared
	fi
	# Install default set of binaries
	emake DESTDIR="${D}" install-common
}

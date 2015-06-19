# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/parmgridgen/parmgridgen-1.0.ebuild,v 1.4 2015/02/22 11:02:10 pacho Exp $

EAPI=2

inherit eutils autotools

MYP=ParMGridGen-${PV}

DESCRIPTION="Software for parallel (mpi) generating coarse grids"
HOMEPAGE="http://www-users.cs.umn.edu/~moulitsa/software.html"
SRC_URI="http://www-users.cs.umn.edu/~moulitsa/download/${MYP}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror bindist"

DEPEND="virtual/mpi"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MYP}

pkg_setup(){
	export CC=mpicc
}

src_prepare() {
	epatch "${FILESDIR}/${P}-autotools.patch"
	epatch "${FILESDIR}/${P}-as-needed.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README Doc/*.pdf || die
}

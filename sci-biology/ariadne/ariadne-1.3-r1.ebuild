# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/ariadne/ariadne-1.3-r1.ebuild,v 1.9 2013/04/11 18:42:50 ulm Exp $

inherit toolchain-funcs eutils

DESCRIPTION="Protein sequences and profiles comparison"

HOMEPAGE="http://www.well.ox.ac.uk/ariadne/"
SRC_URI="http://www.well.ox.ac.uk/${PN}/${P}.tar.Z"

LICENSE="ARIADNE"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=sci-biology/ncbi-tools-0.20041020-r1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/SRC-${PV}"

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc4.patch
	sed -e "s/CC = gcc/CC = $(tc-getCC)/" \
		-e "s/OPTIMISE = -O2/OPTIMISE = ${CFLAGS}/" \
		-i Makefile || die
	sed -e "s/blosum62/BLOSUM62/" -i prospero.c || die
}

src_install() {
	dobin Linux/{ariadne,prospero} || die
	dolib Linux/libseq.a || die
	insinto /usr/include/${PN}
	doins Include/*.h || die
	dodoc README || die
}

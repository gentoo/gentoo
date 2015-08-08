# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Estimated Locations of Pattern Hits - Motif finder program"
LICENSE="Artistic"
HOMEPAGE="http://cbcb.umd.edu/software/ELPH/"
SRC_URI="ftp://ftp.cbcb.umd.edu/pub/software/elph/ELPH-${PV}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="x86"

S="${WORKDIR}/ELPH/sources"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-usage.patch
	sed -i -e "s/CC      := g++/CC      := $(tc-getCXX)/" \
		-e "s/-fno-exceptions -fno-rtti -D_REENTRANT -g/${CXXFLAGS}/" \
		-e "s/LINKER    := g++/LINKER    := $(tc-getCXX)/" \
		Makefile || die "Failed to patch Makefile."
}

src_compile() {
	make || die "Compilation failed."
}

src_install() {
	dobin elph || die "Failed to install program."
	cd "${WORKDIR}"/ELPH
	dodoc VERSION || die "Documentation installation failed."
	newdoc Readme.ELPH README || die "Readme installation failed."
}

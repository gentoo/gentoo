# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs fixheadtails

DESCRIPTION="Library created from code by Dan Bernstein"
HOMEPAGE="http://www.fefe.de/djb/"
SRC_URI="http://www.fefe.de/djb/djb-${PV}.tar.bz2"

LICENSE="all-rights-reserved public-domain"
SLOT="0"
KEYWORDS="~x86 ~ppc"
RESTRICT="mirror bindist"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	ht_fix_file */Makefile.static
	for cc in */conf-cc ; do echo "$(tc-getCC) ${CFLAGS}" > ${cc} ; done
	for ld in */conf-ld ; do echo "$(tc-getCC) ${LDFLAGS}" > ${ld} ; done
}

src_compile() {
	emake || die
}

src_install() {
	for lib in */*.a ; do
		newlib.a ${lib} libdjb-$(basename ${lib}) || die "newlib failed"
	done
	for man in */*.3 ; do
		newman ${man} ${PN}-$(basename ${man})
	done
	exeinto /usr/lib/${PN}
	doexe *.pl || die "doexe .pl failed"
	dodoc CHANGES TODO
}

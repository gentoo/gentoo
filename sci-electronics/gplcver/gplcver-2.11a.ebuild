# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

MY_PN=gpl-cver

DESCRIPTION="Verilog simulator"
HOMEPAGE="http://www.pragmatic-c.com/${MY_PN}"
SRC_URI="http://www.pragmatic-c.com/${MY_PN}/downloads/${P}.src.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""
S=${WORKDIR}/${P}.src

src_unpack() {
	unpack ${A}
	sed -i -e "s/^\(CFLAGS= .*\)/#\1\nCFLAGS=\$(WARNS) \$(INCS) ${CFLAGS}/" ${S}/src/makefile.lnx
	sed -i -e "s/^\(CFLAGS= .*\)/#\1\nCFLAGS= ${CFLAGS}/" ${S}/vcddiff.dir/src/makefile.lnx
}

src_compile(){
	cd ${S}/src
	emake -f makefile.lnx || die
	cd ${S}/vcddiff.dir/src
	emake -f makefile.lnx || die
}

src_install() {
	dodir /usr
	dodir /usr/bin
	dobin bin/cver bin/vcddiff || die
	doman doc/systasks.1
	dodoc doc/README doc/cver*[!htm] doc/dbg.hlp doc/systasks.pdf vcddiff.dir/README.vcddiff
	dohtml doc/cver.faq.htm
	dodir /usr/include/cver_pli_incs
	insinto /usr/include/cver_pli_incs
	doins pli_incs/*.h
}

src_test() {
	# fixme: make tests die if something fails
	cd ${S}/tests_and_examples/
	# first verify install
	cd install.tst
	./inst_tst.sh
	# now individual tests
	cd ../capacity.tst
	../../bin/cver -f lfsr.vc
	diff verilog.log lfsr.plg
	cd ../examples.acc
	./inst_pli.sh lnx
	#opt_inst_pli.sh lnx
	cd ../examples.tf
	./inst_pli.sh lnx
	#opt_inst_pli.sh lnx
	cd ../examples.vpi
	./inst_pli.sh lnx
}

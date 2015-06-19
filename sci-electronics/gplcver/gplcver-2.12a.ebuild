# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gplcver/gplcver-2.12a.ebuild,v 1.4 2015/01/28 05:51:04 tomjbe Exp $

MY_PN=gpl-cver

DESCRIPTION="Verilog simulator"
HOMEPAGE="http://sourceforge.net/projects/${PN}"
SRC_URI="http://www.pragmatic-c.com/${MY_PN}/downloads/${P}.src.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
S=${WORKDIR}/${P}.src

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s/^CFLAGS/#CFLAGS/" \
		-e "s/(CFLAGS)/(INCS) \$(CFLAGS)/" \
		-e "s/(LFLAGS)/(LFLAGS) \$(LDFLAGS)/" \
		src/makefile.* || die "sed failed"
	sed -i \
		-e "s/^CFLAGS/#CFLAGS/" \
		-e "s/(OPTFLGS) vcddiff.o/(LDFLAGS) vcddiff.o/" \
		vcddiff.dir/src/makefile.* || die "sed failed"
}

src_compile(){
	cd "${S}"/src
	emake -f makefile.lnx || die "emake failed"
	cd "${S}"/vcddiff.dir/src
	emake -f makefile.lnx || die "emake failed"
}

src_install() {
	dobin bin/cver bin/vcddiff || die "Failed installing binaries"
	doman doc/systasks.1
	dodoc doc/README doc/cver*[!htm] doc/dbg.hlp doc/systasks.pdf vcddiff.dir/README.vcddiff
	dohtml doc/cver.faq.htm
	dodir /usr/include/cver_pli_incs
	insinto /usr/include/cver_pli_incs
	doins pli_incs/*.h
}

src_test() {
	# fixme: make tests die if something fails
	cd "${S}"/tests_and_examples/
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

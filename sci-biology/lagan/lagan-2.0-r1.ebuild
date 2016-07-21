# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

MY_P="lagan20"

DESCRIPTION="LAGAN, Multi-LAGAN, Shuffle-LAGAN, Supermap: Whole-genome multiple alignment of genomic DNA"
HOMEPAGE="http://lagan.stanford.edu/lagan_web/index.shtml"
SRC_URI="http://lagan.stanford.edu/lagan_web/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i "/use Getopt::Long;/ i use lib \"/usr/share/${PN}/lib\";" "${S}/supermap.pl" || die
	# NB: Testing with glibc-2.10 has uncovered a bug in src/utils/Sequence.h where libc getline is erroneously used instead of own getline
	sed -i 's/getline/my_getline/' "${S}"/src/{anchors.c,glocal/io.cpp} || die
	epatch "${FILESDIR}"/${P}-*.patch
}

src_install() {
	dobin lagan.pl slagan.pl mlagan
	rm lagan.pl slagan.pl utils/Utils.pm
	dodir /usr/share/${PN}/lib
	insinto /usr/share/${PN}/lib
	doins Utils.pm
	exeinto /usr/share/${PN}/utils
	doexe utils/*
	exeinto /usr/share/${PN}
	doexe *.pl anchors chaos glocal order prolagan
	insinto /usr/share/${PN}
	doins *.txt
	dosym /usr/share/${PN}/supermap.pl /usr/bin/supermap
	dosym /usr/bin/lagan.pl /usr/bin/lagan
	dosym /usr/bin/slagan.pl /usr/bin/slagan
	echo "LAGAN_DIR=\"/usr/share/${PN}\"" > ${S}/99${PN}
	doenvd "${S}/99${PN}"
	dodoc Readmes/README.*
}

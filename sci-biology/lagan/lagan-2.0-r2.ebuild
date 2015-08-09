# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils multilib toolchain-funcs

MY_P="lagan20"

DESCRIPTION="LAGAN, Multi-LAGAN, Shuffle-LAGAN, Supermap: Whole-genome multiple alignment of genomic DNA"
HOMEPAGE="http://lagan.stanford.edu/lagan_web/index.shtml"
SRC_URI="http://lagan.stanford.edu/lagan_web/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i "/use Getopt::Long;/ i use lib \"/usr/$(get_libdir)/${PN}/lib\";" "${S}/supermap.pl" || die
	# NB: Testing with glibc-2.10 has uncovered a bug in src/utils/Sequence.h where libc getline is erroneously used instead of own getline
	sed -i 's/getline/my_getline/' "${S}"/src/{anchors.c,glocal/io.cpp} || die
	epatch "${FILESDIR}"/${P}-*.patch
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CXXFLAGS="${CXXFLAGS}" \
		CFLAGS="${CFLAGS}"
}

src_install() {
	newbin lagan.pl lagan || die
	newbin slagan.pl slagan || die
	dobin mlagan || die
	rm lagan.pl slagan.pl utils/Utils.pm

	insinto /usr/$(get_libdir)/${PN}/lib
	doins Utils.pm || die
	exeinto /usr/$(get_libdir)/${PN}/utils
	doexe utils/* || die
	exeinto /usr/$(get_libdir)/${PN}
	doexe *.pl anchors chaos glocal order prolagan || die
	insinto /usr/$(get_libdir)/${PN}
	doins *.txt || die
	dosym /usr/$(get_libdir)/${PN}/supermap.pl /usr/bin/supermap
	echo "LAGAN_DIR=\"/usr/$(get_libdir)/${PN}\"" > ${S}/99${PN}
	doenvd "${S}/99${PN}" || die
	dodoc Readmes/README.* || die
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/njplot/njplot-2.3-r1.ebuild,v 1.1 2015/03/02 13:14:37 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A phylogenetic tree drawing program which supports tree rooting"
HOMEPAGE="http://pbil.univ-lyon1.fr/software/njplot.html"
SRC_URI="ftp://pbil.univ-lyon1.fr/pub/mol_phylogeny/njplot/archive/njplot-${PV}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-biology/ncbi-tools[X,static-libs]
	x11-libs/libXmu"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s%njplot.help%${EPREFIX}/usr/share/doc/${PF}/njplot.help%" njplot-vib.c || die
	epatch \
		"${FILESDIR}"/${P}-format-security.patch \
		"${FILESDIR}"/${P}-buildsystem.patch
	tc-export CC
}

src_install() {
	dobin newicktops newicktotxt njplot unrooted
	doman *.1
	dodoc README njplot.help
}

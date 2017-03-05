# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A phylogenetic tree drawing program which supports tree rooting"
HOMEPAGE="http://pbil.univ-lyon1.fr/software/njplot.html"
SRC_URI="ftp://pbil.univ-lyon1.fr/pub/mol_phylogeny/njplot/archive/njplot-${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-biology/ncbi-tools[X,static-libs]
	x11-libs/libXmu"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-buildsystem.patch
)

src_prepare() {
	default
	sed -i -e "s:njplot.help:${EPREFIX}/usr/share/doc/${PF}/njplot.help:" njplot-vib.c || die

	tc-export CC
}

src_install() {
	dobin newicktops newicktotxt njplot unrooted
	doman *.1
	dodoc README njplot.help
}

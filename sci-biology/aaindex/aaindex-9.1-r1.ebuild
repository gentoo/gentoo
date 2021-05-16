# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Amino acid indices and similarity matrices"
HOMEPAGE="https://www.genome.jp/aaindex/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emboss minimal"

DEPEND="emboss? ( sci-biology/emboss )"
RDEPEND="${DEPEND}"

src_compile() {
	if use emboss; then
		mkdir AAINDEX || die
		einfo
		einfo "Indexing AAindex for usage with EMBOSS."
		EMBOSS_DATA="." aaindexextract -auto -infile ${PN}1 || die "Indexing AAindex failed"
		einfo
	fi
}

src_install() {
	dodoc ${PN}.doc

	if ! use minimal; then
		insinto /usr/share/${PN}
		doins ${PN}{1,2,3}
	fi

	if use emboss; then
		insinto /usr/share/EMBOSS/data/AAINDEX
		doins -r AAINDEX/.
	fi
}

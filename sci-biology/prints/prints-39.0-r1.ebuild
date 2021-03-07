# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="${PV/./_}"

DESCRIPTION="A protein motif fingerprint database"
HOMEPAGE="http://www.bioinf.man.ac.uk/dbbrowser/PRINTS/"
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
		mkdir PRINTS || die
		einfo
		einfo "Indexing PRINTS for usage with EMBOSS"
		EMBOSS_DATA="." printsextract -auto -infile prints${MY_PV}.dat || die "Indexing PRINTS failed"
		einfo
	fi
}

src_install() {
	dodoc README

	if ! use minimal; then
		insinto /usr/share/${PN}
		doins newpr.lis ${PN}${MY_PV}.{all.fasta,dat,kdat,lis,nam,vsn}
	fi

	if use emboss; then
		insinto /usr/share/EMBOSS/data/${PN^^}
		doins -r ${PN^^}/.
	fi
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Codon usage tables calculated from GenBank"
HOMEPAGE="http://www.kazusa.or.jp/codon/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
IUSE="emboss minimal"
RESTRICT="binchecks strip"

RDEPEND="emboss? ( sci-biology/emboss )"
BDEPEND="${RDEPEND}"

src_compile() {
	if use emboss; then
		mkdir CODONS || die
		ebegin "Indexing CUTG for usage with EMBOSS."
		EMBOSS_DATA="." cutgextract -auto -directory "${S}"
		eend $? "Indexing CUTG failed" || die
	fi
}

src_install() {
	dodoc README CODON_LABEL SPSUM_LABEL

	if ! use minimal; then
		insinto /usr/share/cutg
		doins *.codon *.spsum
	fi

	if use emboss; then
		insinto /usr/share/EMBOSS/data
		doins -r CODONS
	fi
}

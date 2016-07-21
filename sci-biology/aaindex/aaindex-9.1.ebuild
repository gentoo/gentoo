# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Amino acid indices and similarity matrices"
LICENSE="public-domain"
HOMEPAGE="http://www.genome.ad.jp/aaindex"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
IUSE="emboss minimal"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

DEPEND="emboss? ( sci-biology/emboss )"

RDEPEND="${DEPEND}"

src_compile() {
	if use emboss; then
		mkdir AAINDEX
		echo
		einfo "Indexing AAindex for usage with EMBOSS."
		EMBOSS_DATA="." aaindexextract -auto -infile ${PN}1 || die \
			"Indexing AAindex failed."
		echo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins ${PN}{1,2,3} || die "Failed to install raw database."
	fi
	dodoc ${PN}.doc || die "Failed to install documentation."
	if use emboss; then
		insinto /usr/share/EMBOSS/data/AAINDEX
		doins AAINDEX/* || die "Failed to install EMBOSS data files."
	fi
}

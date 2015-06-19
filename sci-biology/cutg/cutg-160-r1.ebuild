# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/cutg/cutg-160-r1.ebuild,v 1.5 2015/03/28 21:39:28 ago Exp $

EAPI=5

DESCRIPTION="Codon usage tables calculated from GenBank"
HOMEPAGE="http://www.kazusa.or.jp/codon/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="public-domain"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
IUSE="emboss minimal"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

DEPEND="emboss? ( sci-biology/emboss )"
RDEPEND="${DEPEND}"

RESTRICT="binchecks strip"

src_compile() {
	if use emboss; then
		mkdir CODONS || die
		ebegin "Indexing CUTG for usage with EMBOSS."
		EMBOSS_DATA="." cutgextract -auto -directory "${S}" || die \
			"Indexing CUTG failed."
		eend
	fi
}

src_install() {
	local file
	dodoc README CODON_LABEL SPSUM_LABEL
	if ! use minimal; then
		dodir /usr/share/${PN}
		mv *.codon *.spsum "${ED}"/usr/share/${PN} || die \
			"Installing raw CUTG database failed."
	fi

	if use emboss; then
		dodir /usr/share/EMBOSS/data/CODONS
		cd CODONS || die
		for file in *; do
			mv ${file} "${ED}"/usr/share/EMBOSS/data/CODONS/ || die \
				"Installing the EMBOSS-indexed database failed."
		done
	fi
}

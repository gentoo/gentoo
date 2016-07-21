# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_PV="${PV/./_}"

DESCRIPTION="A protein motif fingerprint database"
HOMEPAGE="http://www.bioinf.man.ac.uk/dbbrowser/PRINTS/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
LICENSE="public-domain"
IUSE="emboss minimal"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

DEPEND="emboss? ( sci-biology/emboss )"
RDEPEND="${DEPEND}"

src_compile() {
	if use emboss; then
		mkdir PRINTS || die
		echo
		einfo "Indexing PRINTS for usage with EMBOSS."
		EMBOSS_DATA="." printsextract -auto -infile prints${MY_PV}.dat || die \
			"Indexing PRINTS failed."
		echo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins newpr.lis ${PN}${MY_PV}.{all.fasta,dat,kdat,lis,nam,vsn} || die \
			"Installing raw database failed."
	fi
	if use emboss; then
		insinto /usr/share/EMBOSS/data/PRINTS
		doins PRINTS/* || die "Installing EMBOSS data files failed."
	fi
	dodoc README || die "Documentation installation failed."
}

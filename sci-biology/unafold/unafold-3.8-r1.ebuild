# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/unafold/unafold-3.8-r1.ebuild,v 1.1 2013/02/18 11:10:31 jlec Exp $

EAPI=5

inherit flag-o-matic

DESCRIPTION="Unified Nucleic Acid Folding and hybridization package"
HOMEPAGE="http://mfold.rna.albany.edu/"
SRC_URI="http://dinamelt.bioinfo.rpi.edu/download/${P}.tar.bz2"

LICENSE="unafold"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="custom-cflags"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	# recommended in README
	use custom-cflags || append-flags -O3

	sed \
		-e 's:hybrid (UNAFold) 3.7:hybrid (UNAFold) 3.8:g' \
		-i tests/hybrid.tml || die
}

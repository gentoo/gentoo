# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit flag-o-matic

DESCRIPTION="Unified Nucleic Acid Folding and hybridization package"
HOMEPAGE="http://mfold.rna.albany.edu/"
SRC_URI="http://dinamelt.bioinfo.rpi.edu/download/${P}.tar.bz2"

LICENSE="unafold"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	# recommended in README
	append-flags -O3

	sed \
		-e 's:hybrid (UNAFold) 3.7:hybrid (UNAFold) 3.8:g' \
		-i tests/hybrid.tml || die
}

src_install() {
	einstall || die
}

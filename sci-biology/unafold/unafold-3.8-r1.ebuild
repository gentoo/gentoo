# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Unified Nucleic Acid Folding and hybridization package"
HOMEPAGE="http://mfold.rna.albany.edu/"
SRC_URI="http://dinamelt.bioinfo.rpi.edu/download/${P}.tar.bz2"

LICENSE="unafold"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="custom-cflags"

RDEPEND="
	media-libs/freeglut
	media-libs/gd
	virtual/opengl"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-doc-version.patch )

src_configure() {
	# recommended in README
	use custom-cflags || append-flags -O3

	default
}

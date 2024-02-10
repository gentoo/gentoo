# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Unified Nucleic Acid Folding and hybridization package"
HOMEPAGE="http://mfold.rna.albany.edu/"
SRC_URI="http://dinamelt.bioinfo.rpi.edu/download/${P}.tar.bz2"

LICENSE="unafold"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/freeglut
	media-libs/gd
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="dev-build/autoconf-archive"

PATCHES=(
	"${FILESDIR}"/${P}-doc-version.patch
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-coverage
}

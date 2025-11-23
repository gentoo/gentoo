# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tools for Short Read FASTA/FASTQ file processing"
HOMEPAGE="http://hannonlab.cshl.edu/fastx_toolkit"
SRC_URI="https://github.com/agordon/fastx_toolkit/releases/download/${PV}/${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sci-biology/libgtextutils:="
RDEPEND="
	${DEPEND}
	dev-perl/PerlIO-gzip
	dev-perl/GDGraph
	sci-visualization/gnuplot"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

src_prepare() {
	default
	eautoreconf
}

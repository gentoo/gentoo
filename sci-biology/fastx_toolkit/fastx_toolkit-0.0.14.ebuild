# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Tools for Short Read FASTA/FASTQ file processing"
HOMEPAGE="http://hannonlab.cshl.edu/fastx_toolkit"
SRC_URI="https://github.com/agordon/fastx_toolkit/releases/download/${PV}/${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sci-biology/libgtextutils
	virtual/pkgconfig"
RDEPEND="
	dev-perl/PerlIO-gzip
	dev-perl/GDGraph
	sci-biology/libgtextutils:=
	sci-visualization/gnuplot"

PATCHES=(
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

src_prepare() {
	default
	eautoreconf
}

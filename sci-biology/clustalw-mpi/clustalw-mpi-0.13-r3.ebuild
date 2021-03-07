# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An MPI implemention of the ClustalW general purpose multiple alignment algorithm"
HOMEPAGE="http://www.bii.a-star.edu.sg/achievements/applications/clustalw/index.php"
SRC_URI="http://web.bii.a-star.edu.sg/~kuobin/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mpi-njtree static-pairalign"

DEPEND="virtual/mpi"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	if use mpi-njtree; then
		sed -e "s/TREES_FLAG/#TREES_FLAG/" -i Makefile || \
			die "Failed to configure MPI code for NJ trees"
	fi

	if use static-pairalign; then
		sed -e "s/DDYNAMIC_SCHEDULING/DSTATIC_SCHEDULING/" -i Makefile || \
			die "Failed to configure static scheduling for pair alignments"
	fi
}

src_install() {
	dobin clustalw-mpi
	newdoc README.clustalw-mpi README
}

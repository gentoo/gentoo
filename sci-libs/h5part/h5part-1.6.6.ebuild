# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P^^[hp]}"
DESCRIPTION="Portable High Performance Parallel Data Interface to HDF5"
HOMEPAGE="http://vis.lbl.gov/Research/H5Part/"
SRC_URI="https://codeforge.lbl.gov/frs/download.php/latestfile/18/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	virtual/mpi
	sci-libs/hdf5[mpi]
	"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-mpio.patch" )

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf --enable-parallel --enable-shared --disable-static CC=mpicc CXX=mpicxx
}

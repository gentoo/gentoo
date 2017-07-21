# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P="${P^h}"
DESCRIPTION="High-Performance I/O Library for Particle-based Simulations"
HOMEPAGE="http://www-vis.lbl.gov/Research/H5hut/"
SRC_URI="https://amas.psi.ch/H5hut/raw-attachment/wiki/DownloadSources/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	virtual/mpi
	sci-libs/hdf5[mpi]
	"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-mpio.patch"
	"${FILESDIR}/${P}-autotools.patch"
	)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-parallel --enable-shared --disable-static CC=mpicc CXX=mpicxx
}

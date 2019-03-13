# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Software for Calculating Scattering Diagrams on Massively Parallel Computers"
HOMEPAGE="https://github.com/benlabs/sassena"
SRC_URI="https://github.com/benlabs/sassena/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="
	dev-libs/boost[mpi]
	dev-libs/libxml2
	sci-libs/fftw:3.0
	sci-libs/hdf5[mpi]
	virtual/blas
	virtual/lapack
	virtual/mpi
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}_cmake-remove-missing.patch"
	"${FILESDIR}/${P}_uint32_t.patch"
	"${FILESDIR}/${P}_link_boost_thread.patch"
)

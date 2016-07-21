# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Software for Calculating Scattering Diagrams on Massively Parallel Computers"
HOMEPAGE="http://www.sassena.org"
SRC_URI="https://github.com/benlabs/sassena/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="
		dev-libs/boost[mpi]
		sci-libs/hdf5[mpi]
		dev-libs/libxml2
		sci-libs/fftw:3.0
		virtual/mpi
		virtual/blas
		virtual/lapack"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}_cmake-remove-missing.patch"
	"${FILESDIR}/${P}_uint32_t.patch"
	"${FILESDIR}/${P}_link_boost_thread.patch"
)

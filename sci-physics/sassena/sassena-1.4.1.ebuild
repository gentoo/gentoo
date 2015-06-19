# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/sassena/sassena-1.4.1.ebuild,v 1.1 2012/04/29 11:33:27 alexxy Exp $

EAPI=4

inherit cmake-utils

MY_P="${PN}-v${PV}"

DESCRIPTION="Software for Calculating Scattering Diagrams on Massively Parallel Computers"
HOMEPAGE="http://www.sassena.org"
SRC_URI="http://www.sassena.org/software/source-code/releases/v${PV}/${MY_P}.tar.gz/at_download/file -> ${MY_P}.tar.gz"

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

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/$P-libs.patch"
	)

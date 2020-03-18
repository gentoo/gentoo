# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake cuda

DESCRIPTION="An auto-parallelizing library to speed up computer simulations"
HOMEPAGE="
	http://www.libgeodecomp.org
	https://github.com/STEllAR-GROUP/libgeodecomp"
SRC_URI="http://www.libgeodecomp.org/archive/${P}.tar.bz2"

SLOT="0"
LICENSE="Boost-1.0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cuda doc hpx mpi opencl opencv silo"

BDEPEND="
	doc? (
		app-doc/doxygen
		app-text/texlive
		media-gfx/graphviz
		)"
RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}
	<dev-libs/libflatarray-0.3.0
	cuda? ( dev-util/nvidia-cuda-toolkit )
	hpx? ( sys-cluster/hpx )
	mpi? ( virtual/mpi )
	opencl? ( virtual/opencl )
	opencv? ( media-libs/opencv )
	silo? ( sci-libs/silo )"

S="${WORKDIR}/${P}"
PATCHES=(
	"${FILESDIR}/${P}-scotch.patch"
	"${FILESDIR}/${P}-libdir.patch"
	"${FILESDIR}/${P}-lfa.patch"
	"${FILESDIR}/${P}-boost.patch"
)

src_prepare() {
	cmake_src_prepare
	use cuda && cuda_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_CUDA=$(usex cuda)
		-DWITH_HPX=$(usex hpx)
		-DWITH_MPI=$(usex mpi)
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_OPENCV=$(usex opencv)
		-DWITH_SCOTCH=false
		-DWITH_SILO=$(usex silo)
		-DWITH_TYPEMAPS=false
		-DWITH_VISIT=false
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doc
}

src_install() {
	DOCS=( README )
	use doc && HTML_DOCS=( doc/html/* )
	cmake_src_install
}

src_test() {
	cmake_build check
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils cuda flag-o-matic git-r3 python-single-r1

DESCRIPTION="a general-purpose particle simulation toolkit"
HOMEPAGE="http://codeblue.umich.edu/hoomd-blue/"
EGIT_REPO_URI="https://bitbucket.org/glotzer/${PN}.git"

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64"
	EGIT_COMMIT="v${PV}"
fi

LICENSE="hoomd-blue"
SLOT="0"
IUSE="cuda test mpi +zlib"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	mpi? ( virtual/mpi )
	cuda? ( dev-util/nvidia-cuda-sdk )
	zlib? ( sys-libs/zlib )
	dev-libs/boost:=[threads,python,mpi,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	use cuda && cuda_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_MPI=$(usex mpi)
		-DENABLE_DOXYGEN=OFF #$(
		-DENABLE_CUDA=$(usex cuda)
		-DBUILD_TESTING=$(usex test)
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DCMAKE_INSTALL_PREFIX=$(python_get_sitedir)
	)
	cmake-utils_src_configure
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils cuda flag-o-matic python-r1

DESCRIPTION="a general-purpose particle simulation toolkit"
HOMEPAGE="http://codeblue.umich.edu/hoomd-blue/"
EGIT_REPO_URI="https://bitbucket.org/glotzer/${PN}.git"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://bitbucket.org/glotzer/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	GETTAR_VER=0.5.0
	SRC_URI="https://bitbucket.org/glotzer/${PN}/get/v${PV}.tar.bz2 -> ${P}.tar.bz2
		https://bitbucket.org/glotzer/libgetar/get/v${GETTAR_VER}.tar.bz2 -> libgetar-${GETTAR_VER}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="hoomd-blue"
SLOT="0"
IUSE="cuda test mpi"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	mpi? ( virtual/mpi )
	cuda? ( dev-util/nvidia-cuda-sdk )
	dev-libs/boost:=[threads,python,mpi,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	[[ ${PV} = 9999 ]] || mv ../libgetar-${GETTAR_VER}/* hoomd/extern/libgetar || die
	use cuda && cuda_src_prepare
	cmake-utils_src_prepare

	#https://bitbucket.org/glotzer/hoomd-blue/issues/173
	append-cxxflags -std=gnu++11
}

src_configure() {
	src_configure_internal() {
		local mycmakeargs=(
			-DENABLE_MPI=$(usex mpi)
			-DENABLE_CUDA=$(usex cuda)
			-DBUILD_TESTING=$(usex test)
			-DUPDATE_SUBMODULES=OFF
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DCMAKE_INSTALL_PREFIX=$(python_get_sitedir)
		)
		cmake-utils_src_configure
	}
	python_foreach_impl src_configure_internal
}

src_compile() {
	python_foreach_impl cmake-utils_src_make
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

src_install() {
	python_foreach_impl cmake-utils_src_install
}

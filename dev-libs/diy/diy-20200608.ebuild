# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="header only C++ library for data-parallel out-of-core"
HOMEPAGE="https://gitlab.kitware.com/diatomic/diy"
SRC_URI=https://gitlab.kitware.com/diatomic/diy/-/archive/for/vtk-m-${PV}-master/diy-for-vtk-m-${PV}-master.tar.gz
S="${WORKDIR}"/diy-for-vtk-m-${PV}-master
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/mpi:=[cxx]
"
DEPEND="examples? ( ${RDEPEND} )
BDEPEND="
	examples? ( ${RDEPEND} )
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/diy-20200608-cmake.patch )

src_configure() {
	export CC=mpicc \
	       CXX=mpicxx

	local mycmakeargs=(
		-Dmpi=ON
		-Ddiy_prefix=diy
		-Dbuild_examples=$(usex examples)
		-Dbuild_tests=$(usex test)
		-Ddiy_install_lib_dir="$(get_libdir)"
	)
	cmake_src_configure
}

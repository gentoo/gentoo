# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
CMAKE_MAKEFILE_GENERATOR=emake
# Doc building insists on fetching mathjax
# DOCS_BUILDER="doxygen"
# DOCS_DEPEND="
# 	media-gfx/graphviz
# 	dev-libs/mathjax
# "

inherit cmake fortran-2 distutils-r1 # docs

convert_month() {
	local months=( "" Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec )
	echo ${months[${1#0}]}
}

MY_PV="$((10#${PV:6:2}))$(convert_month ${PV:4:2})${PV:0:4}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Large-scale Atomic/Molecular Massively Parallel Simulator"
HOMEPAGE="https://lammps.sandia.gov/"
SRC_URI="https://download.lammps.org/tars/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/cmake"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="cuda examples gzip hip lammps-memalign mpi opencl python test"
# Requires write access to /dev/dri/renderD...
RESTRICT="test"

RDEPEND="
	app-arch/gzip
	media-libs/libpng:0
	sys-libs/zlib
	mpi? (
		virtual/mpi
		sci-libs/hdf5:=[mpi]
	)
	python? ( ${PYTHON_DEPS} )
	sci-libs/voro++
	virtual/blas
	virtual/lapack
	sci-libs/fftw:3.0=
	sci-libs/netcdf:=
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1:= )
	opencl? ( virtual/opencl )
	hip? ( dev-util/hip:= )
	dev-cpp/eigen:3
	"
	# Kokkos-3.5 not in tree atm
	# kokkos? ( dev-cpp/kokkos-3.5.* )
BDEPEND="${DISTUTILS_DEPS}"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
	)
"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	?? ( cuda opencl hip )
"

src_prepare() {
	cmake_src_prepare
	if use python; then
		pushd ../python || die
		distutils-r1_src_prepare
		popd
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_MPI=$(usex mpi)
		-DBUILD_DOC=OFF
		#-DBUILD_DOC=$(usex doc)
		-DENABLE_TESTING=$(usex test)
		-DPKG_ASPHERE=ON
		-DPKG_BODY=ON
		-DPKG_CLASS2=ON
		-DPKG_COLLOID=ON
		-DPKG_COMPRESS=ON
		-DPKG_CORESHELL=ON
		-DPKG_DIPOLE=ON
		-DPKG_GRANULAR=ON
		-DPKG_KSPACE=ON
		-DFFT=FFTW3
		-DPKG_KOKKOS=OFF
		#-DPKG_KOKKOS=$(usex kokkos)
		#$(use kokkos && echo -DEXTERNAL_KOKKOS=ON)
		-DPKG_MANYBODY=ON
		-DPKG_MC=ON
		-DPKG_MEAM=ON
		-DPKG_MISC=ON
		-DPKG_MOLECULE=ON
		-DPKG_PERI=ON
		-DPKG_QEQ=ON
		-DPKG_REPLICA=ON
		-DPKG_RIGID=ON
		-DPKG_SHOCK=ON
		-DPKG_SRD=ON
		-DPKG_PYTHON=$(usex python)
		-DPKG_MPIIO=$(usex mpi)
		-DPKG_VORONOI=ON
	)
	if use cuda || use opencl || use hip; then
		mycmakeargs+=( -DPKG_GPU=ON )
		use cuda && mycmakeargs+=( -DGPU_API=cuda )
		use opencl && mycmakeargs+=( -DGPU_API=opencl -DUSE_STATIC_OPENCL_LOADER=OFF )
		use hip && mycmakeargs+=( -DGPU_API=hip )
	else
		mycmakeargs+=( -DPKG_GPU=OFF )
	fi
	cmake_src_configure
	if use python; then
		pushd ../python || die
		distutils-r1_src_configure
		popd
	fi
}

src_compile() {
	cmake_src_compile
	if use python; then
		pushd ../python || die
		distutils-r1_src_compile
		popd
	fi
}

src_test() {
	cmake_src_test
	if use python; then
		pushd ../python || die
		distutils-r1_src_test
		popd
	fi
}

src_install() {
	cmake_src_install
	if use python; then
		pushd ../python || die
		distutils-r1_src_install
		popd
	fi

	if use examples; then
		for d in examples bench; do
			local LAMMPS_EXAMPLES="/usr/share/${PN}/${d}"
			insinto "${LAMMPS_EXAMPLES}"
			doins -r "${S}"/../${d}/*
		done
	fi
}

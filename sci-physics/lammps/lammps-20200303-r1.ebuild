# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake fortran-2 python-r1

convert_month() {
	local months=( "" Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec )
	echo ${months[${1#0}]}
}

MY_PV="stable_$((10#${PV:6:2}))$(convert_month ${PV:4:2})${PV:0:4}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Large-scale Atomic/Molecular Massively Parallel Simulator"
HOMEPAGE="https://lammps.sandia.gov/"
SRC_URI="https://github.com/lammps/lammps/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	test? ( https://github.com/lammps/lammps-testing/archive/${MY_PV}.tar.gz -> ${PN}-testing-${MY_PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda examples gzip kokkos lammps-memalign mpi netcdf python test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/gzip
	media-libs/libpng:0
	sys-libs/zlib
	mpi? (
		virtual/mpi
		sci-libs/hdf5[mpi]
	)
	python? ( ${PYTHON_DEPS} )
	sci-libs/voro++
	virtual/blas
	virtual/lapack
	sci-libs/fftw:3.0
	netcdf? ( sci-libs/netcdf )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 )
	kokkos? ( =dev-cpp/kokkos-3.0* )
	dev-cpp/eigen:3
	"
RDEPEND="${DEPEND}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}/cmake"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_MPI=$(usex mpi)
		-DBUILD_LIB=ON
		-DPKG_GPU=$(usex cuda)
		-DGPU_API=CUDA
		-DENABLE_TESTING=$(usex test)
		-DLAMMPS_TESTING_SOURCE_DIR=$(echo "${WORKDIR}"/lammps-testing-*)
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
		-DPKG_KOKKOS=$(usex kokkos)
		$(use kokkos && echo -DEXTERNAL_KOKKOS=ON)
		-DPKG_MANYBODY=ON
		-DPKG_MC=ON
		-DPKG_MEAM=ON
		-DPKG_MISC=ON
		-DPKG_MOLECULE=ON
		-DPKG_PERI=ON
		-DPKG_QEQ=ON
		-DPKG_REAX=ON
		-DPKG_REPLICA=ON
		-DPKG_RIGID=ON
		-DPKG_SHOCK=ON
		-DPKG_SNAP=ON
		-DPKG_SRD=ON
		-DPKG_PYTHON=ON
		-DPKG_MPIIO=$(usex mpi)
		-DPKG_VORONOI=ON
		-DPKG_USER-ATC=ON
		-DPKG_USER-AWPMD=ON
		-DPKG_USER-CGDNA=ON
		-DPKG_USER-CGSDK=ON
		-DPKG_USER-COLVARS=ON
		-DPKG_USER-DIFFRACTION=ON
		-DPKG_USER-DPD=ON
		-DPKG_USER-DRUDE=ON
		-DPKG_USER-EFF=ON
		-DPKG_USER-FEP=ON
		-DPKG_USER-H5MD=$(usex mpi)
		-DPKG_USER-LB=$(usex mpi)
		-DPKG_USER-MANIFOLD=ON
		-DPKG_USER-MEAMC=ON
		-DPKG_USER-MGPT=ON
		-DPKG_USER-MISC=ON
		-DPKG_USER-MOLFILE=ON
		-DPKG_USER-NETCDF=$(usex netcdf)
		-DPKG_USER-PHONON=ON
		-DPKG_USER-QTB=ON
		-DPKG_USER-REAXC=ON
		-DPKG_USER-SMD=ON
		-DPKG_USER-SMTBQ=ON
		-DPKG_USER-SPH=ON
		-DPKG_USER-TALLY=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Install python script.
	use python && python_foreach_impl python_domodule "${S}"/../python/lammps.py

	if use examples; then
		for d in examples bench; do
			local LAMMPS_EXAMPLES="/usr/share/${PN}/${d}"
			insinto "${LAMMPS_EXAMPLES}"
			doins -r "${S}"/../${d}/*
		done
	fi
}

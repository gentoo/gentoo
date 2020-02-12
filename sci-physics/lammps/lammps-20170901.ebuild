# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit cmake-utils fortran-2 python-r1

convert_month() {
	local months=( "" Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec )
	echo ${months[${1#0}]}
}

MY_PV="patch_$((10#${PV:6:2}))$(convert_month ${PV:4:2})${PV:0:4}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Large-scale Atomic/Molecular Massively Parallel Simulator"
HOMEPAGE="https://lammps.sandia.gov/"
SRC_URI="https://github.com/lammps/lammps/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda examples gzip lammps-memalign mpi netcdf python test"
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
	dev-cpp/eigen:3
	"
RDEPEND="${DEPEND}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}/cmake"

src_configure() {
	local mycmakeargs=(
	    -DBUILD_SHARED_LIBS=ON
		-DENABLE_MPI=$(usex mpi)
		-DENABLE_GPU=$(usex cuda)
		-DENABLE_TESTING=$(usex test)
		-DENABLE_ASPHERE=ON
		-DENABLE_BODY=ON
		-DENABLE_CLASS2=ON
		-DENABLE_COLLOID=ON
		-DENABLE_COMPRESS=ON
		-DENABLE_CORESHELL=ON
		-DENABLE_DIPOLE=ON
		-DENABLE_GRANULAR=ON
		-DENABLE_KSPACE=ON
		-DFFT=FFTW3
		-DENABLE_MANYBODY=ON
		-DENABLE_MC=ON
		-DENABLE_MEAM=ON
		-DENABLE_MISC=ON
		-DLAMMPS_XDR=ON #630444
		-DENABLE_MOLECULE=ON
		-DENABLE_PERI=ON
		-DENABLE_QEQ=ON
		-DENABLE_REAX=ON
		-DENABLE_REPLICA=ON
		-DENABLE_RIGID=ON
		-DENABLE_SHOCK=ON
		-DENABLE_SNAP=ON
		-DENABLE_SRD=ON
		-DENABLE_PYTHON=ON
		-DENABLE_MPIIO=$(usex mpi)
		-DENABLE_VORONOI=ON
		-DENABLE_USER-ATC=ON
		-DENABLE_USER-AWPMD=ON
		-DENABLE_USER-CGDNA=ON
		-DENABLE_USER-CGSDK=ON
		-DENABLE_USER-COLVARS=ON
		-DENABLE_USER-DIFFRACTION=ON
		-DENABLE_USER-DPD=ON
		-DENABLE_USER-DRUDE=ON
		-DENABLE_USER-EFF=ON
		-DENABLE_USER-FEP=ON
		-DENABLE_USER-H5MD=$(usex mpi)
		-DENABLE_USER-LB=$(usex mpi)
		-DENABLE_USER-MANIFOLD=ON
		-DENABLE_USER-MEAMC=ON
		-DENABLE_USER-MGPT=ON
		-DENABLE_USER-MISC=ON
		-DENABLE_USER-MOLFILE=ON
		-DENABLE_USER-NETCDF=$(usex netcdf)
		-DENABLE_USER-PHONON=ON
		-DENABLE_USER-QTB=ON
		-DENABLE_USER-REAXC=ON
		-DENABLE_USER-SMD=ON
		-DENABLE_USER-SMTBQ=ON
		-DENABLE_USER-SPH=ON
		-DENABLE_USER-TALLY=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	local LAMMPS_POTENTIALS="usr/share/${PN}/potentials"
	insinto "/${LAMMPS_POTENTIALS}"
	doins "${S}"/../potentials/*
	echo "LAMMPS_POTENTIALS=${EROOT}${LAMMPS_POTENTIALS}" > 99lammps
	doenvd 99lammps

	# Install python script.
	use python && python_foreach_impl python_domodule "${S}"/../python/lammps.py

	if use examples; then
		local LAMMPS_EXAMPLES="/usr/share/${PN}/examples"
		insinto "${LAMMPS_EXAMPLES}"
		doins -r "${S}"/../examples/*
	fi
}

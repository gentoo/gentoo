# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic fortran-2 multilib

convert_month() {
	case $1 in
		01) echo Jan
			;;
		02) echo Feb
			;;
		03) echo Mar
			;;
		04) echo Apr
			;;
		05) echo May
			;;
		06) echo Jun
			;;
		07) echo Jul
			;;
		08) echo Aug
			;;
		09) echo Sep
			;;
		10) echo Oct
			;;
		11) echo Nov
			;;
		12) echo Dec
			;;
		*)  echo unknown
			;;
	esac
}

MY_P=${PN}-$((10#${PV:6:2}))$(convert_month ${PV:4:2})${PV:2:2}

DESCRIPTION="Large-scale Atomic/Molecular Massively Parallel Simulator"
HOMEPAGE="https://lammps.sandia.gov/"
SRC_URI="https://lammps.sandia.gov/tars/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples gzip lammps-memalign mpi static-libs"

DEPEND="
	mpi? (
		virtual/blas
		virtual/lapack
		virtual/mpi
	)
	sci-libs/voro++
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

lmp_emake() {
	local LAMMPS_INCLUDEFLAGS
	LAMMPS_INCLUDEFLAGS="$(usex gzip '-DLAMMPS_GZIP' '')"
	LAMMPS_INCLUDEFLAGS+="$(usex lammps-memalign ' -DLAMMPS_MEMALIGN' '')"

	# The lammps makefile uses CC to indicate the C++ compiler.
	emake \
		ARCHIVE=$(tc-getAR) \
		CC=$(usex mpi "mpic++" "$(tc-getCXX)") \
		F90=$(usex mpi "mpif90" "$(tc-getFC)") \
		LINK=$(usex mpi "mpic++" "$(tc-getCXX)") \
		CCFLAGS="${CXXFLAGS}" \
		F90FLAGS="${FCFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		LMP_INC="${LAMMPS_INCLUDEFLAGS}" \
		MPI_INC=$(usex mpi '' "-I../STUBS") \
		MPI_PATH=$(usex mpi '' '-L../STUBS') \
		MPI_LIB=$(usex mpi '' '-lmpi_stubs') \
		user-atc_SYSLIB="$(usex mpi "$($(tc-getPKG_CONFIG) --libs blas) $($(tc-getPKG_CONFIG) --libs lapack)" '')"\
		"$@"
}

src_prepare() {
	# Fix inconsistent use of SHFLAGS.
	sed -i \
		-e 's:voronoi_SYSINC\s\+=.*$:voronoi_SYSINC = -I/usr/include/voro++:' \
		-e 's:voronoi_SYSPATH\s\+=.*$:voronoi_SYSPATH =:' \
		lib/voronoi/Makefile.lammps || die

	# Fix missing .so name.
	sed -i \
		-e 's:SHLIBFLAGS\s\+=\s\+:SHLIBFLAGS = -Wl,-soname,liblammps.so.0 :' \
		src/MAKE/Makefile.serial || die

	# Fix makefile in tools.
	sed -i \
		-e 's:g++:$(CXX) $(CXXFLAGS):' \
		-e 's:gcc:$(CC) $(CCFLAGS):' \
		-e 's:ifort:$(FC) $(FCFLAGS):' \
		tools/Makefile || die
}

src_compile() {
	# Prepare compiler flags.
	append-cxxflags -fPIC -I../../src
	append-fflags -fPIC

	# Compile stubs for serial version.
	use mpi || lmp_emake -C src stubs

	# Build packages
	emake -C src yes-asphere
	emake -C src yes-body
	emake -C src yes-class2
	emake -C src yes-colloid
	emake -C src yes-dipole
	emake -C src yes-fld
	#emake -C src yes-gpu
	emake -C src yes-granular
	# Need OpenKIM external dependency.
	#emake -C src yes-kim
	# Need Kokkos external dependency.
	#emake -C src yes-kokkos
	emake -C src yes-kspace
	emake -C src yes-manybody
	emake -C src yes-mc
	lmp_emake -C src yes-meam
	lmp_emake -j1 -C lib/meam -f Makefile.gfortran
	emake -C src yes-misc
	emake -C src yes-molecule
	#emake -C src yes-mpiio
	emake -C src yes-opt
	emake -C src yes-peri
	emake -C src yes-poems
	lmp_emake -C lib/poems -f Makefile.g++
	emake -C src yes-reax
	lmp_emake -j1 -C lib/reax -f Makefile.gfortran
	emake -C src yes-replica
	emake -C src yes-rigid
	emake -C src yes-shock
	emake -C src yes-snap
	emake -C src yes-srd
	emake -C src yes-voronoi
	emake -C src yes-xtc

	emake -C src yes-user-eff
	emake -C src yes-user-fep
	use mpi && emake -C src yes-user-lb
	emake -C src yes-user-phonon
	emake -C src yes-user-sph

	if use mpi; then
		emake -C src yes-user-atc
		lmp_emake -C lib/atc -f Makefile.g++
	fi

	if use static-libs; then
		# Build static library.
		lmp_emake -C src makelib
		lmp_emake -C src -f Makefile.lib serial
	fi

	# Build shared library.
	lmp_emake -C src makeshlib
	lmp_emake -C src -f Makefile.shlib serial

	# Compile main executable.
	lmp_emake -C src serial

	# Compile tools.
	emake -C tools binary2txt chain micelle2d data2xmovie
}

src_install() {
	use static-libs && newlib.a src/liblammps_serial.a liblammps.a
	newlib.so src/liblammps_serial.so liblammps.so.0.0.0
	dosym liblammps.so.0.0.0 /usr/$(get_libdir)/liblammps.so
	dosym liblammps.so.0.0.0 /usr/$(get_libdir)/liblammps.so.0
	newbin src/lmp_serial lmp
	dobin tools/binary2txt
	# Don't forget to add header files of optional packages as they are added
	# to this ebuild. There may also be .mod files from Fortran based
	# packages.
	insinto "/usr/include/${PN}"
	doins -r src/*.h lib/meam/*.mod

	local LAMMPS_POTENTIALS="usr/share/${PN}/potentials"
	insinto "/${LAMMPS_POTENTIALS}"
	doins potentials/*
	echo "LAMMPS_POTENTIALS=${EROOT}${LAMMPS_POTENTIALS}" > 99lammps
	doenvd 99lammps

	if use examples; then
		local LAMMPS_EXAMPLES="/usr/share/${PN}/examples"
		insinto "${LAMMPS_EXAMPLES}"
		doins -r examples/*
	fi

	dodoc README
	if use doc; then
		dodoc doc/Manual.pdf
		dohtml -r doc/*
	fi
}

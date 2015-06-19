# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/lammps/lammps-20150430.ebuild,v 1.1 2015/05/03 02:52:39 nicolasbock Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit eutils flag-o-matic fortran-2 multilib python-r1

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
HOMEPAGE="http://lammps.sandia.gov/"
SRC_URI="http://lammps.sandia.gov/tars/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gzip lammps-memalign mpi python static-libs"

DEPEND="
	mpi? (
		virtual/blas
		virtual/lapack
		virtual/mpi
	)
	gzip? ( app-arch/gzip )
	sci-libs/voro++
	python? ( ${PYTHON_DEPS} )
	"
RDEPEND="${DEPEND}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

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
		MPI_INC=$(usex mpi "" "-I../STUBS") \
		MPI_PATH=$(usex mpi "" "-L../STUBS") \
		MPI_LIB=$(usex mpi "" "-lmpi_stubs") \
		user-atc_SYSLIB="$(usex mpi "$($(tc-getPKG_CONFIG) --libs blas) $($(tc-getPKG_CONFIG) --libs lapack)" '')"\
		"$@"
}

lmp_activate_packages() {
	# Build packages
	lmp_emake -C src yes-asphere
	lmp_emake -C src yes-body
	lmp_emake -C src yes-class2
	lmp_emake -C src yes-colloid
	lmp_emake -C src yes-coreshell
	lmp_emake -C src yes-dipole
	lmp_emake -C src yes-fld
	#lmp_emake -C src yes-gpu
	lmp_emake -C src yes-granular
	# Need OpenKIM external dependency.
	#lmp_emake -C src yes-kim
	# Need Kokkos external dependency.
	#lmp_emake -C src yes-kokkos
	lmp_emake -C src yes-kspace
	lmp_emake -C src yes-manybody
	lmp_emake -C src yes-mc
	lmp_emake -C src yes-meam
	lmp_emake -C src yes-misc
	lmp_emake -C src yes-molecule
	#lmp_emake -C src yes-mpiio
	lmp_emake -C src yes-opt
	lmp_emake -C src yes-peri
	lmp_emake -C src yes-poems
	lmp_emake -C src yes-qeq
	lmp_emake -C src yes-reax
	lmp_emake -C src yes-replica
	lmp_emake -C src yes-rigid
	lmp_emake -C src yes-shock
	lmp_emake -C src yes-snap
	lmp_emake -C src yes-srd
	lmp_emake -C src yes-voronoi
	lmp_emake -C src yes-xtc

	if use mpi; then
		lmp_emake -C src yes-user-atc
	fi
	lmp_emake -C src yes-user-eff
	lmp_emake -C src yes-user-fep
	use mpi && lmp_emake -C src yes-user-lb
	lmp_emake -C src yes-user-phonon
	lmp_emake -C src yes-user-sph
}

lmp_build_packages() {
	lmp_emake -C lib/meam -j1 -f Makefile.gfortran
	lmp_emake -C lib/poems -f Makefile.g++
	lmp_emake -C lib/reax -j1 -f Makefile.gfortran
	use mpi && lmp_emake -C lib/atc -f Makefile.g++
}

lmp_clean_packages() {
	lmp_emake -C lib/meam -f Makefile.gfortran clean
	lmp_emake -C lib/poems -f Makefile.g++ clean
	lmp_emake -C lib/reax -f Makefile.gfortran clean
	use mpi && lmp_emake -C lib/atc -f Makefile.g++ clean
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

	# Patch python.
	epatch "${FILESDIR}/lammps-python3.patch"
	epatch "${FILESDIR}/python-shebang.patch"
}

src_compile() {
	# Fix atc...
	append-cxxflags -I../../src

	# Acticate packages.
	elog "Activating lammps packages..."
	lmp_activate_packages

	# Compile stubs for serial version.
	use mpi || lmp_emake -C src mpi-stubs

	elog "Building packages..."
	lmp_build_packages

	if use static-libs; then
		# Build static library.
		elog "Building static library..."
		lmp_emake -C src mode=lib serial
	fi

	# Clean out packages (that's not done by the build system with the clean
	# target), so we can rebuild the packages with -fPIC.
	elog "Cleaning packages..."
	lmp_clean_packages

	# The build system does not rebuild the packages with -fPIC, adding flag
	# manually.
	append-cxxflags -fPIC
	append-fflags -fPIC

	# Compile stubs for serial version.
	use mpi || lmp_emake -C src mpi-stubs

	elog "Building packages..."
	lmp_build_packages

	# Build shared library.
	elog "Building shared library..."
	lmp_emake -C src mode=shlib serial

	# Compile main executable. The shared library is always built, and
	# mode=shexe is simply a way to re-use the object files built in the
	# "shlib" step when linking the executable. The executable is not actually
	# using the shared library. If we have built the static library, then we
	# link that into the executable.
	elog "Linking executable..."
	if use static-libs; then
		lmp_emake -C src mode=exe serial
	else
		lmp_emake -C src mode=shexe serial
	fi

	# Compile tools.
	elog "Building tools..."
	lmp_emake -C tools binary2txt chain data2xmovie micelle2d
}

src_install() {
	use static-libs && newlib.a src/liblammps_serial.a liblammps.a
	newlib.so src/liblammps_serial.so liblammps.so.0.0.0
	dosym liblammps.so.0.0.0 /usr/$(get_libdir)/liblammps.so
	dosym liblammps.so.0.0.0 /usr/$(get_libdir)/liblammps.so.0
	newbin src/lmp_serial lmp
	dobin tools/binary2txt
	dobin tools/chain
	dobin tools/data2xmovie
	dobin tools/micelle2d
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

	# Install python script.
	use python && python_foreach_impl python_domodule python/lammps.py

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

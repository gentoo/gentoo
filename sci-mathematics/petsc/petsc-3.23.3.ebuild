# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit flag-o-matic fortran-2 python-any-r1 toolchain-funcs

DESCRIPTION="Portable, Extensible Toolkit for Scientific Computation"
HOMEPAGE="https://petsc.org/release/"
SRC_URI="https://web.cels.anl.gov/projects/petsc/download/release-snapshots/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="afterimage boost complex-scalars cuda debug +examples fftw fortran
	hdf5 hypre int64 mpi metis mumps scotch superlu threads X"

# readd sparse when suitesparse-5.6.0 is in tree
# sparse? ( >=sci-libs/suitesparse-5.6.0 >=sci-libs/cholmod-1.7.0 )
# $(use_with sparse suitesparse) \
RDEPEND="
	virtual/blas
	virtual/lapack

	afterimage? ( media-libs/libafterimage )
	boost? ( dev-libs/boost )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-3.2 )
	fftw? ( sci-libs/fftw:3.0[mpi?] )
	hdf5? ( sci-libs/hdf5:=[mpi?] )
	hypre? ( >=sci-libs/hypre-2.18.0[int64?,mpi?] )
	metis? ( >=sci-libs/parmetis-4 )
	mpi? ( virtual/mpi[fortran?] )
	mumps? ( sci-libs/mumps[mpi?] sci-libs/scalapack )
	scotch? ( sci-libs/scotch[int64?,mpi?] )
	superlu? ( >=sci-libs/superlu-5 )
	X? ( x11-libs/libX11 )
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
	dev-build/cmake
	virtual/pkgconfig
"

# hypre and superlu curretly exclude each other due to missing linking to hypre
# if both are enabled
REQUIRED_USE="
	afterimage? ( X )
	complex-scalars? ( !hypre !superlu )
	fftw? ( mpi )
	hdf5? ( mpi )
	hypre? ( mpi !superlu )
	mumps? ( mpi scotch )
	scotch? ( mpi )
	superlu? ( !hypre )
"
PATCHES=(
	"${FILESDIR}/${PN}-3.21.3-disable-rpath.patch"
	"${FILESDIR}"/${PN}-3.21.3-fix_sandbox_violation.patch
)

# petsc uses --with-blah=1 and --with-blah=0 to en/disable options
petsc_enable() {
	use "$1" && echo "--with-${2:-$1}=1" || echo "--with-${2:-$1}=0"
}
# add external library:
# petsc_with use_flag libname libdir
# petsc_with use_flag libname include linking_libs
petsc_with() {
	local myuse p=${2:-${1}}
	if use ${1}; then
		myuse="--with-${p}=1"
		if [[ $# -ge 4 ]]; then
			myuse="${myuse} --with-${p}-include=${EPREFIX}${3}"
			shift 3
			myuse="${myuse} --with-${p}-lib=$@"
		else
			myuse="${myuse} --with-${p}-dir=${EPREFIX}${3:-/usr}"
		fi
	else
		myuse="--with-${p}=0"
	fi
	echo ${myuse}
}

# select between configure options depending on use flag
petsc_select() {
	use "$1" && echo "--with-$2=$3" || echo "--with-$2=$4"
}

src_configure() {
	# bug 548498
	# PETSc runs mpi processes during configure that result in a sandbox
	# violation by trying to open /proc/mtrr rw. This is not easy to
	# mitigate because it happens in libpciaccess.so called by libhwloc.so,
	# which is used by libmpi.so.
	addpredict /proc/mtrr
	# if mpi is built with knem support it needs /dev/knem too
	addpredict /dev/knem

	# configureMPITypes with openmpi-2* insists on accessing the scaling
	# governor rw.
	addpredict /sys/devices/system/cpu/

	# bug 771711
	# configureMPIEXEC and  configureMPITypes access /dev/nvidiactl
	addpredict /dev/nvidiactl

	# bug 810841
	addpredict /dev/kfd

	local myopt

	use debug && myopt="debug" || myopt="opt"

	# environmental variables expected by petsc during build

	export PETSC_DIR="${S}"
	export PETSC_ARCH="linux-gnu-c-${myopt}"

	if use debug; then
		strip-flags
		filter-flags -O*
	fi

	tc-export AR RANLIB

	# C Support on CXX builds is enabled if possible i.e. when not using
	# complex scalars (no complex type for both available at the same time)

	econf \
		scrollOutput=1 \
		AR="${AR}" \
		CFLAGS="${CFLAGS} -fPIC" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS} -fPIC" \
		CXXOPTFLAGS="${CXXFLAGS} -fPIC" \
		FCFLAGS="${FCFLAGS} -fPIC" \
		FFLAGS="${FFLAGS} -fPIC" \
		LDFLAGS="${LDFLAGS}" \
		MAKEFLAGS="${MAKEFLAGS}" \
		RANLIB="${RANLIB}" \
		--prefix="${EPREFIX}/usr/$(get_libdir)/petscdir/" \
		--with-blas-lapack-lib="$($(tc-getPKG_CONFIG) --libs blas lapack)" \
		--with-cmake:BOOL=1 \
		--with-gnu-compilers \
		--with-imagemagick=0 \
		--with-petsc-arch="${PETSC_ARCH}" \
		--with-precision=double \
		--with-python=0 \
		--with-shared-libraries \
		--with-single-library \
		--with-windows-graphics=0 \
		$(petsc_enable cuda cudac) \
		$(petsc_enable debug debugging) \
		$(petsc_enable fortran) \
		$(petsc_enable mpi) \
		$(petsc_enable mpi mpi-compilers) \
		$(petsc_enable threads pthread) \
		$(petsc_select complex-scalars scalar-type complex real) \
		$(petsc_select mpi cc mpicc $(tc-getCC)) \
		$(petsc_select mpi cxx mpicxx $(tc-getCXX)) \
		$(petsc_select mpi fc mpif90 $(tc-getFC)) \
		$(petsc_with afterimage afterimage /usr/include/libAfterImage -lAfterImage) \
		$(petsc_with hypre hypre /usr/include/hypre -lHYPRE) \
		$(petsc_with superlu superlu /usr/include/superlu -lsuperlu) \
		$(petsc_with scotch ptscotch /usr/include/scotch [-lptesmumps,-lptscotch,-lptscotcherr,-lscotch,-lscotcherr]) \
		$(petsc_with mumps scalapack /usr/include/scalapack -lscalapack) \
		$(petsc_with mumps mumps /usr/include [-lcmumps,-ldmumps,-lsmumps,-lzmumps,-lmumps_common,-lpord]) \
		$(use fortran && echo "$(petsc_select mpi fc mpif77 $(tc-getF77))") \
		$(use int64 && echo "--with-index-size=64") \
		$(use_with boost) \
		$(use_with fftw) \
		$(use_with hdf5) \
		$(use_with X x) \
		$(use_with X x11)
}

src_install() {
	emake DESTDIR="${ED}" install

	#
	# Clean up the mess:
	#

	# put all include directories under a proper subdirectory
	mkdir "${ED}"/usr/include || die "mkdir failed (include)"
	mv "${ED}"/usr/{$(get_libdir)/petscdir/include,include/petsc} || die "mv failed (include)"

	# put libraries and pkconfig file into proper place
	mv "${ED}"/usr/$(get_libdir)/petscdir/lib/{libpetsc*,pkgconfig} \
		"${ED}/usr/$(get_libdir)" || die "mv failed (lib)"

	# move share to proper location
	mv "${ED}"/usr/{$(get_libdir)/petscdir/share,share} || die "mv failed (share)"

	# fix pc files:
	sed -i \
		-e 's#include$#include/petsc#' \
		-e "s#lib\$#$(get_libdir)#" \
		-e "s#^prefix=.*petscdir\$#prefix=${EPREFIX}/usr#" \
		"${ED}"/usr/$(get_libdir)/pkgconfig/*.pc || die "sed failed (pkgconfig)"

	# recreate a "valid" petscdir:
	for i in "${ED}"/usr/$(get_libdir)/*; do
		[ $(basename $i) = petscdir ] && continue
		ln -s "${EPREFIX}/usr/$(get_libdir)/$(basename $i)" \
			"${ED}/usr/$(get_libdir)/petscdir/lib/$(basename $i)" || die "ln failed (petscdir)"
	done
	ln -s "${EPREFIX}"/usr/include/petsc/ \
		"${ED}/usr/$(get_libdir)/petscdir/include" || die "ln failed (petscdir)"
	mkdir "${ED}/usr/$(get_libdir)/petscdir/share" || die "mkdir fialed (petscdir)"
	ln -s "${EPREFIX}"/usr/share/petsc/ \
		"${ED}/usr/$(get_libdir)/petscdir/share/petsc" || die "ln failed (petscdir)"

	# automatically symlink petsc matlab modules:
	mkdir -p "${ED}"/usr/share/octave/site/m/
	ln -s "${EPREFIX}"/usr/share/petsc/matlab "${ED}"/usr/share/octave/site/m/petsc || die "ln failed (matlab)"

	if use examples; then
		mkdir -p "${ED}"/usr/share/doc/${PF} || die "mkdir failed (examples)"
		mv "${ED}"/usr/share/petsc/examples "${ED}"/usr/share/doc/${PF} || die "mv failed (examples)"
		ln -s "${EPREFIX}"/usr/share/doc/${PF}/examples "${ED}"/usr/share/petsc/examples || die "ln failed (examples)"
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -r "${ED}"/usr/share/petsc/examples || die "rm failed (examples)"
	fi

	# add PETSC_DIR to environmental variables
	cat >> 99petsc <<- EOF
		PETSC_DIR=${EPREFIX}/usr/$(get_libdir)/petscdir
	EOF
	doenvd 99petsc
}

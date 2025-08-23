# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multilib toolchain-funcs

MY_P=flexiblas-release-v${PV}
DESCRIPTION="A BLAS and LAPACK wrapper library with runtime exchangable backends"
HOMEPAGE="
	https://www.mpi-magdeburg.mpg.de/projects/flexiblas/
	https://gitlab.mpi-magdeburg.mpg.de/software/flexiblas-release/
"
SRC_URI="
	https://gitlab.mpi-magdeburg.mpg.de/software/flexiblas-release/-/archive/v${PV}/${MY_P}.tar.bz2
"
S=${WORKDIR}/${MY_P}

# BSD for vendored cblas/lapacke
LICENSE="LGPL-3+ BSD"
SLOT="0"
# TODO: 64bit-index
IUSE="blis mkl openblas openmp tbb test"
RESTRICT="!test? ( test )"

# flexiblas only supports gnu-openmp using clang/gcc
DEPEND="
	sci-libs/lapack:=[deprecated]
	blis? ( sci-libs/blis:=[-64bit-index] )
	mkl? (
		sci-libs/mkl:=[tbb?]
		openmp? ( sci-libs/mkl[gnu-openmp] )
	)
	openblas? ( sci-libs/openblas:= )
"
RDEPEND="
	${DEPEND}
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
	fi
}

src_prepare() {
	cmake_src_prepare

	# remove bundled netlib blas/lapack
	# (we still need vendored cblas/lapacke)
	rm -r contributed/lapack-* || die
}

src_configure() {
	BACKENDS=( $(usev blis) $(usev openblas) )
	local extra=${BACKENDS[*]}
	local libdir="${ESYSROOT}/usr/$(get_libdir)"
	local mycmakeargs=(
		-DTESTS=$(usex test)
		-DCBLAS=ON
		# TODO: ILP64 variant
		-DINTEGER8=OFF
		-DLAPACK=ON
		-DLINK_OPENMP=$(usex openmp)
		-DEXAMPLES=OFF
		# we need to enable autodetection for mkl
		-DBLAS_AUTO_DETECT=ON
		# ...so we need to explicitly disable autodetecting other libraries
		# that would be pinned to their openmp/pthread/serial variants
		-DOpenBLASSerial=OFF
		-DOpenBLASPThread=OFF
		-DOpenBLASOpenMP=OFF
		-DBlisSerial=OFF
		-DBlisPThread=OFF
		-DBlisOpenMP=OFF
		# variants we use autodetection for
		-DMklSerial=$(usex mkl ON OFF)
		-DMklOpenMP=$(usex mkl "$(usex openmp ON OFF)" OFF)
		-DMklTBB=$(usex mkl "$(usex tbb ON OFF)" OFF)
		# unsupported
		-DCMAKE_DISABLE_FIND_PACKAGE_nvpl=ON
		-DATLAS=OFF
		-DTATLAS=OFF
		# and then enable our custom names via EXTRA
		-DEXTRA="${extra// /;}"
		# respect CFLAGS
		-DLTO=OFF
		# use system sci-libs/lapack
		-DSYS_BLAS_LIBRARY="${libdir}/libblas.so"
		-DSYS_LAPACK_LIBRARY="${libdir}/liblapack.so"
		# these are used only with -DEXTRA
		-Dblis_LIBRARY="${libdir}/libblis.so"
		-Dopenblas_LIBRARY="${libdir}/libopenblas.so"
	)

	cmake_src_configure

	BACKENDS+=( netlib )
	if use mkl; then
		BACKENDS+=(
			MklSerial
			$(usev openmp MklOpenMP)
			$(usev tbb MklTBB)
		)
	fi
}

src_test() {
	# We run tests in parallel, so avoid having n^2 threads.
	local -x BLIS_NUM_THREADS=1
	local -x MKL_NUM_THREADS=1
	local -x OMP_NUM_THREADS=1
	local -x OPENBLAS_NUM_THREADS=1

	local failures=()
	local backend
	for backend in "${BACKENDS[@]}"; do
		# TODO: remove this, and XFAIL them properly when cmake.eclass
		# is fixed to respect nonfatal, https://bugs.gentoo.org/961929
		if [[ ${backend} == Mkl* ]]; then
			einfo "Skipping ${backend} tests, XFAIL"
			continue
		fi

		local -x FLEXIBLAS_TEST=${backend}
		local log=${BUILD_DIR}/Testing/Temporary/LastTest.log
		einfo "Testing backend ${backend}"
		if ! nonfatal cmake_src_test; then
			failures+=( "${backend}" )
		fi
		if grep -q 'BLAS backend .* not found' "${log}"; then
			die "Backend ${backend} failed to load while testing, see ${log}"
		fi
	done

	if [[ ${failures[@]} ]]; then
		die "Test runs failed for backends: ${failures[*]}"
	fi
}

src_install() {
	cmake_src_install

	# verify built backends
	cd "${ED}/usr/$(get_libdir)/flexiblas" || die
	local missing=()
	local backend
	for backend in "${BACKENDS[@]}"; do
		if [[ ! -f libflexiblas_${backend,,}$(get_libname) ]]; then
			missing+=( "${backend}" )
		fi
	done

	if [[ ${missing[@]} ]]; then
		die "Not all requested backends built. Missing: ${missing[*]}"
	fi
}

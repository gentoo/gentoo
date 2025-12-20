# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic fortran-2 multilib toolchain-funcs

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
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 x86"
IUSE="blis index64 mkl openblas openmp system-blas tbb test"
RESTRICT="!test? ( test )"

# flexiblas only supports gnu-openmp using clang/gcc
DEPEND="
	sci-libs/lapack:=[deprecated,index64(-)?]
	blis? ( sci-libs/blis:=[-64bit-index(-),index64(-)?] )
	mkl? (
		sci-libs/mkl:=[tbb?]
		openmp? ( sci-libs/mkl[gnu-openmp] )
	)
	openblas? ( sci-libs/openblas:=[index64(-)?] )
	system-blas? ( sci-libs/lapack[flexiblas(-)] )
"
RDEPEND="
	${DEPEND}
	system-blas? (
		!app-eselect/eselect-blas
		!app-eselect/eselect-cblas
		!app-eselect/eselect-lapack
		!sci-libs/lapack[-flexiblas(-)]
		!=sci-libs/blas-lapack-aux-wrapper-0-r0
	)
"
PDEPEND="
	system-blas? (
		>=sci-libs/blas-lapack-aux-wrapper-0-r1[index64?]
	)
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		fortran-2_pkg_setup
		use openmp && tc-check-openmp
	fi
}

src_prepare() {
	cmake_src_prepare

	# remove bundled netlib blas/lapack
	# (we still need vendored cblas/lapacke)
	rm -r contributed/lapack-* || die
}

src_configure() {
	# bug #963667
	filter-flags -fno-semantic-interposition

	BACKENDS=( $(usev blis) $(usev openblas) )
	local extra=${BACKENDS[*]}
	local libdir="${ESYSROOT}/usr/$(get_libdir)"
	local mycmakeargs=(
		-DTESTS=$(usex test)
		-DCBLAS=ON
		-DINTEGER8=OFF
		-DLAPACK=ON
		-DLINK_OPENMP=$(usex openmp)
		-DEXAMPLES=OFF
		# prefer OpenBLAS if available
		-DFLEXIBLAS_DEFAULT=$(usex openblas openblas netlib)
		# we need to enable autodetection for mkl
		-DBLAS_AUTO_DETECT=ON
		# ...so we need to explicitly disable autodetecting other libraries
		# that would be pinned to their openmp/pthread/serial variants
		-DOpenBLASSerial=OFF
		-DOpenBLASPThread=OFF
		-DOpenBLASOpenMP=OFF
		-DOpenBLASSerial64=OFF
		-DOpenBLASPThread64=OFF
		-DOpenBLASOpenMP64=OFF
		-DBlisSerial=OFF
		-DBlisPThread=OFF
		-DBlisOpenMP=OFF
		-DBlisSerial64=OFF
		-DBlisPThread64=OFF
		-DBlisOpenMP64=OFF
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
		# these are used only with -DEXTRA
		-Dblis_LIBRARY="${libdir}/libblis.so"
		-Dopenblas_LIBRARY="${libdir}/libopenblas.so"
	)

	# use system sci-libs/lapack
	if use system-blas; then
		# this is sci-libs/lapack[flexiblas] install
		mycmakeargs+=(
			-DSYS_BLAS_LIBRARY="${libdir}/libblas-reference.so"
			-DSYS_LAPACK_LIBRARY="${libdir}/liblapack-reference.so"
		)
	else
		mycmakeargs+=(
			-DSYS_BLAS_LIBRARY="${libdir}/libblas.so"
			-DSYS_LAPACK_LIBRARY="${libdir}/liblapack.so"
		)
	fi

	cmake_src_configure

	if use index64; then
		mycmakeargs+=(
			-DINTEGER8=ON
			-Dblis_LIBRARY="${libdir}/libblis64.so"
			-Dopenblas_LIBRARY="${libdir}/libopenblas64.so"
		)

		if use system-blas; then
			# this is sci-libs/lapack[flexiblas] install
			mycmakeargs+=(
				-DSYS_BLAS_LIBRARY="${libdir}/libblas64-reference.so"
				-DSYS_LAPACK_LIBRARY="${libdir}/liblapack64-reference.so"
			)
		else
			mycmakeargs+=(
				-DSYS_BLAS_LIBRARY="${libdir}/libblas64.so"
				-DSYS_LAPACK_LIBRARY="${libdir}/liblapack64.so"
			)
		fi

		BUILD_DIR=${BUILD_DIR}-ilp64 cmake_src_configure
	fi

	BACKENDS+=( netlib )
	BACKENDS_ILP64=( "${BACKENDS[@]}" )
	if use mkl; then
		BACKENDS+=(
			MklSerial
			$(usev openmp MklOpenMP)
			$(usev tbb MklTBB)
		)
		BACKENDS_ILP64+=(
			MklSerial64
			$(usev openmp MklOpenMP64)
			$(usev tbb MklTBB64)
		)
	fi
}

src_compile() {
	cmake_src_compile
	use index64 && BUILD_DIR=${BUILD_DIR}-ilp64 cmake_src_compile
}

my_test() {
	# We run tests in parallel, so avoid having n^2 threads.
	local -x BLIS_NUM_THREADS=1
	local -x MKL_NUM_THREADS=1
	local -x OMP_NUM_THREADS=1
	local -x OPENBLAS_NUM_THREADS=1

	local backend
	for backend in "${@}"; do
		local args=()
		if [[ ${backend} == Mkl* ]]; then
			# XFAIL
			args+=( -E 'cblat[23]' )
		fi

		local -x FLEXIBLAS_TEST=${backend}
		local log=${BUILD_DIR}/Testing/Temporary/LastTest.log
		einfo "Testing backend ${backend}"
		cmake_src_test "${args[@]}"
		if grep -q 'BLAS backend .* not found' "${log}"; then
			die "Backend ${backend} failed to load while testing, see ${log}"
		fi
	done
}

src_test() {
	my_test "${BACKENDS[@]}"
	use index64 && BUILD_DIR=${BUILD_DIR}-ilp64 my_test "${BACKENDS_ILP64[@]}"
}

verify_backends() {
	local lib=${1}
	shift
	cd "${ED}/usr/$(get_libdir)/${lib}" || die

	local missing=()
	local backend
	for backend in "${@}"; do
		if [[ ! -f libflexiblas_${backend,,}$(get_libname) ]]; then
			missing+=( "${backend}" )
		fi
	done

	if [[ ${missing[@]} ]]; then
		die "Not all requested ${lib} backends built. Missing: ${missing[*]}"
	fi
}

src_install() {
	cmake_src_install
	use index64 && BUILD_DIR=${BUILD_DIR}-ilp64 cmake_src_install

	# Verify built backends.
	verify_backends flexiblas "${BACKENDS[@]}"
	use index64 && verify_backends flexiblas64 "${BACKENDS_ILP64[@]}"

	# Install symlinks for system BLAS / LAPACK use.
	if use system-blas; then
		local libdir="/usr/$(get_libdir)"
		local fn suffix
		for fn in cblas.h lapack.h lapacke{,_config,_mangling,_utils}.h; do
			dosym "flexiblas/${fn}" "/usr/include/${fn}"
		done

		for suffix in '' $(usev index64 64); do
			for fn in blas cblas lapack lapacke; do
				dosym "libflexiblas${suffix}.so.3" \
					"${libdir}/lib${fn}${suffix}.so.3"
			done
		done
	fi
}

pkg_postinst() {
	if use system-blas; then
		# eselect-{blas,lapack} doesn't clean up its configs
		local prev_opt=$(shopt -p nullglob)
		shopt -s nullglob
		local files=(
			"${EROOT}"/etc/ld.so.conf.d/81-blas-*.conf
			"${EROOT}"/etc/ld.so.conf.d/82-lapack-*.conf
		)
		${prev_opt}

		if [[ ${files[@]} ]]; then
			rm -v "${files[@]}"
		fi
	fi
}

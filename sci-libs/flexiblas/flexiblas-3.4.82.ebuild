# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

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
# TODO: mkl, 64bit-index
IUSE="blis openblas openmp test"
RESTRICT="!test? ( test )"

DEPEND="
	sci-libs/lapack:=[deprecated]
	blis? ( sci-libs/blis:=[-64bit-index] )
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
	EXTRA_BACKENDS=( $(usev blis) $(usev openblas) )
	local extra=${EXTRA_BACKENDS[*]}
	local libdir="${ESYSROOT}/usr/$(get_libdir)"
	local mycmakeargs=(
		-DTESTS=$(usex test)
		-DCBLAS=ON
		# TODO: ILP64 variant
		-DINTEGER8=OFF
		-DLAPACK=ON
		-DLINK_OPENMP=$(usex openmp)
		-DEXAMPLES=OFF
		# disable autodetection, we don't want automagic deps
		# plus openblas/blis gets hardcoded as openmp/pthread/serial
		-DBLAS_AUTO_DETECT=OFF
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
}

src_test() {
	# We run tests in parallel, so avoid having n^2 threads.
	local -x BLIS_NUM_THREADS=1
	local -x OMP_NUM_THREADS=1
	local -x OPENBLAS_NUM_THREADS=1

	local backend
	for backend in netlib "${EXTRA_BACKENDS[@]}"; do
		local -x FLEXIBLAS_TEST=${backend}
		local log=${BUILD_DIR}/Testing/Temporary/LastTest.log
		einfo "Testing backend ${backend}"
		cmake_src_test
		if grep -q 'BLAS backend .* not found' "${log}"; then
			die "Backend ${backend} failed to load while testing, see ${log}"
		fi
	done
}

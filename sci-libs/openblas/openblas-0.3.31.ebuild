# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic fortran-2 toolchain-funcs

MY_P=OpenBLAS-${PV}
DESCRIPTION="Optimized BLAS library based on GotoBLAS2"
HOMEPAGE="https://github.com/OpenMathLib/OpenBLAS"
SRC_URI="https://github.com/OpenMathLib/OpenBLAS/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86 ~x64-macos"
IUSE="cpudetection index64 openmp pthread relapack test"
REQUIRED_USE="?? ( openmp pthread )"
RESTRICT="!cpudetection? ( bindist ) !test? ( test )"

BDEPEND="virtual/pkgconfig"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	elog "This software has a massive number of options that"
	elog "are configurable and it is *impossible* for all of"
	elog "those to fit inside any manageable ebuild."
	elog "The Gentoo provided package has enough to build"
	elog "a fully optimized library for your targeted CPU."
	elog "You can set the CPU target using the environment"
	elog "variable - OPENBLAS_TARGET or it will be detected"
	elog "automatically from the target toolchain (supports"
	elog "cross compilation toolchains)."
	elog "You can control the maximum number of threads"
	elog "using OPENBLAS_NTHREAD, default=64 and number of "
	elog "parallel calls to allow before further calls wait"
	elog "using OPENBLAS_NPARALLEL, default=8."
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	fortran-2_pkg_setup
}

src_prepare() {
	default

	# TODO: Unbundle lapack like Fedora does?
	# https://src.fedoraproject.org/rpms/openblas/blob/rawhide/f/openblas-0.2.15-system_lapack.patch

	# Don't build the tests as part of "make all". We'll do
	# it explicitly later if the test phase is enabled.
	sed -i -e "/^all :: tests/s: tests::g" Makefile || die

	# If 64bit-index is needed, create second library with LIBPREFIX=libopenblas64
	if use index64; then
		cp -aL "${S}" "${S}-index64" || die
	fi
}

src_configure() {
	# List of most configurable options is in Makefile.rule.

	# Not an easy fix, https://github.com/xianyi/OpenBLAS/issues/4128
	filter-lto

	tc-export CC FC LD AR AS RANLIB

	# HOSTCC is used for scripting
	export HOSTCC="$(tc-getBUILD_CC)"

	# Threading options
	export USE_THREAD=0
	export USE_OPENMP=0
	if use openmp; then
		USE_THREAD=1
		USE_OPENMP=1
	elif use pthread; then
		USE_THREAD=1
		USE_OPENMP=0
	fi

	# Disable submake with -j and default optimization flags in Makefile.system
	# Makefile.rule says to not modify COMMON_OPT/FCOMMON_OPT...
	export MAKE_NB_JOBS=-1 COMMON_OPT=" " FCOMMON_OPT=" "

	# Target CPU ARCH options generally detected automatically from cross toolchain
	if use cpudetection ; then
		export DYNAMIC_ARCH=1 NO_AFFINITY=1 TARGET=GENERIC
	fi

	case $(tc-get-ptr-size) in
		4)
			# NUM_BUFFERS = MAX(50, (2*NUM_PARALLEL*NUM_THREADS)
			# BUFFER_SIZE = (16 << 20) (on x86)
			# NUM_BUFFERS * BUFFER_SIZE is allocated and must be
			# <4GiB on 32-bit arches (bug #967251).
			#
			# Scale down to 2*8*(16 << 20) = 256MiB for 32-bit
			# arches. This avoids spinning in blas_memory_alloc
			# which doesn't handle ENOMEM.
			export NUM_PARALLEL=${OPENBLAS_NPARALLEL:-2}
			export NUM_THREADS=${OPENBLAS_NTHREAD:-8}
			;;
		8)
			# XXX: The current values here rely on overcommit
			# for most systems (bug #967026).
			export NUM_PARALLEL=${OPENBLAS_NPARALLEL:-8}
			export NUM_THREADS=${OPENBLAS_NTHREAD:-64}
			;;
		*)
			die "Unexpected tc-get-ptr-size. Please file a bug."
			;;
	esac

	# Allow setting OPENBLAS_TARGET to override auto detection in case the
	# toolchain is not enough to detect.
	# https://github.com/xianyi/OpenBLAS/blob/develop/TargetList.txt
	if ! use cpudetection ; then
		if [[ -n "${OPENBLAS_TARGET}" ]] ; then
			export TARGET="${OPENBLAS_TARGET}"
		elif [[ ${CBUILD} != ${CHOST} ]] ; then
			case ${CHOST} in
				aarch64-*)
					export TARGET="ARMV8"
					export BINARY="64"
				;;
				powerpc64le-*)
					export TARGET="POWER8"
					export BUILD_BFLOAT16=1
					export BINARY=64
				;;
			esac
		fi
	fi

	export NO_STATIC=1
	export BUILD_RELAPACK=$(usex relapack 1 0)
	export PREFIX="${EPREFIX}/usr"
}

emake64() {
	emake -C "${S}-index64" \
		INTERFACE64=1 \
		LIBNAMESUFFIX=64 \
		"${@}"
}

src_compile() {
	emake shared

	if use index64; then
		emake64 shared
	fi
}

src_test() {
	emake tests

	if use index64; then
		emake64 tests
	fi
}

src_install() {
	local libdir=$(get_libdir)
	emake install \
		DESTDIR="${D}" \
		OPENBLAS_INCLUDE_DIR='$(PREFIX)'/include/openblas \
		OPENBLAS_LIBRARY_DIR='$(PREFIX)'/${libdir}

	dodoc GotoBLAS_*.txt *.md Changelog.txt

	if use index64; then
		emake64 install \
			DESTDIR="${D}" \
			OPENBLAS_INCLUDE_DIR='$(PREFIX)'/include/openblas64 \
			OPENBLAS_LIBRARY_DIR='$(PREFIX)'/${libdir}
	fi
}

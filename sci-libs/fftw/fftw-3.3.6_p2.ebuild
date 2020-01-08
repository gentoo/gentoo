# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED=fortran

inherit flag-o-matic fortran-2 toolchain-funcs versionator multibuild multilib-minimal

DESCRIPTION="Fast C library for the Discrete Fourier Transform"
HOMEPAGE="http://www.fftw.org/"

MY_P=${PN}-${PV/_p/-pl}

if [[ ${PV} = *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/FFTW/fftw3.git"
else
	SRC_URI="http://www.fftw.org/${PN}-${PV/_p/-pl}.tar.gz"
	KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
fi

LICENSE="GPL-2+"
SLOT="3.0/3"
IUSE="altivec cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_fma3 cpu_flags_x86_fma4 cpu_flags_x86_sse cpu_flags_x86_sse2 doc fortran mpi neon openmp quad static-libs test threads zbus"
RESTRICT="!test? ( test )"

RDEPEND="
	mpi? ( >=virtual/mpi-2.0-r4[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

S=${WORKDIR}/${MY_P}
HTML_DOCS=( doc/html/. )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
		FORTRAN_NEED_OPENMP=1
	fi

	fortran-2_pkg_setup

	MULTIBUILD_VARIANTS=( single double longdouble )
	if use quad; then
		if ! tc-is-gcc; then
			ewarn "quad precision only available for gcc >= 4.6"
			die "need quad precision capable gcc"
		fi
		MULTIBUILD_VARIANTS+=( quad )
	fi
}

src_prepare() {
	default

	# fix info file for category directory
	if [[ ${PV} = *9999 ]]; then
		sed -i -e
			's/Texinfo documentation system/Libraries/' \
			doc/fftw3."info" || die "failed to fix info file"

		eautoreconf
	fi
}

multilib_src_configure() {
	# jlec reported USE=quad on abi_x86_32 has too few registers
	# stub Makefiles
	if [[ ${MULTILIB_ABI_FLAG} == abi_x86_32 && ${MULTIBUILD_ID} == quad-* ]]; then
		mkdir -p "${BUILD_DIR}/tests" || die
		echo "all: ;" > "${BUILD_DIR}/Makefile" || die
		echo "install: ;" >> "${BUILD_DIR}/Makefile" || die
		echo "smallcheck: ;" > "${BUILD_DIR}/tests/Makefile" || die
		return 0
	fi

	local myconf=(
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable "cpu_flags_x86_fma$(usex cpu_flags_x86_fma3 3 4)" fma)
		$(use_enable fortran)
		$(use_enable zbus mips-zbus-timer)
		$(use_enable threads)
		$(use_enable openmp)
	)
	case "${MULTIBUILD_ID}" in
		single-*)
			# altivec, sse, single-paired only work for single
			myconf+=(
				--enable-single
				$(use_enable altivec)
				$(use_enable cpu_flags_x86_avx avx)
				$(use_enable cpu_flags_x86_avx2 avx2)
				$(use_enable cpu_flags_x86_sse sse)
				$(use_enable cpu_flags_x86_sse2 sse2)
				$(use_enable neon)
				$(use_enable mpi)
			)
			;;

		double-*)
			myconf+=(
				$(use_enable cpu_flags_x86_avx avx)
				$(use_enable cpu_flags_x86_avx2 avx2)
				$(use_enable cpu_flags_x86_sse2 sse2)
				$(use_enable mpi)
			)
			;;

		longdouble-*)
			myconf+=(
				--enable-long-double
				$(use_enable mpi)
			)
			;;

		quad-*)
			# quad does not support mpi
			myconf+=(
				--enable-quad-precision
			)
			;;

		*)
			die "${MULTIBUILD_ID%-*} precision not implemented in this ebuild"
			;;
	esac

	ECONF_SOURCE="${S}" econf "${myconf[@]}" MPICC="$(tc-getCC) -lmpi"
}

src_configure() {
	multibuild_foreach_variant multilib-minimal_src_configure
}

src_compile() {
	multibuild_foreach_variant multilib-minimal_src_compile
}

multilib_src_test() {
	emake -C tests smallcheck
}

src_test() {
	# We want this to be a reasonably quick test, but that is still hard...
	ewarn "This test series will take 30 minutes on a modern 2.5Ghz machine"
	# Do not increase the number of threads, it will not help your performance
	# local testbase="perl check.pl --nthreads=1 --estimate"
	#     ${testbase} -${p}d || die "Failure: $n"

	multibuild_foreach_variant multilib-minimal_src_test
}

src_install() {
	multibuild_foreach_variant multilib-minimal_src_install
	dodoc CONVENTIONS

	if use doc; then
		dodoc doc/*.pdf
		docinto faq
		dodoc -r doc/FAQ/fftw-faq.html/.
	else
		rm -r "${ED%/}"/usr/share/doc/${PF}/html || die
	fi

	local x
	for x in "${ED%/}"/usr/lib*/pkgconfig/*.pc; do
		local u
		for u in $(usev mpi) $(usev threads) $(usex openmp omp ""); do
			sed -e "s|-lfftw3[flq]\?|&_${u} &|" "$x" > "${x%.pc}_${u}.pc" || die
		done
	done

	# fftw uses pkg-config to record its private dependencies
	find "${D}" -name '*.la' -delete || die
}

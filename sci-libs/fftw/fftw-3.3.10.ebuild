# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED=fortran

inherit fortran-2 libtool multibuild multilib-minimal toolchain-funcs

DESCRIPTION="Fast C library for the Discrete Fourier Transform"
HOMEPAGE="https://www.fftw.org/"

MY_P=${PN}-${PV/_p/-pl}

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/FFTW/fftw3.git"
else
	SRC_URI="https://www.fftw.org/${PN}-${PV/_p/-pl}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="3.0/3"
IUSE="cpu_flags_arm_neon cpu_flags_ppc_altivec cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_fma3 cpu_flags_x86_fma4 cpu_flags_x86_sse cpu_flags_x86_sse2 doc fortran mpi openmp test threads zbus"
RESTRICT="!test? ( test )"

RDEPEND="mpi? ( >=virtual/mpi-2.0-r4[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-lang/perl )"

HTML_DOCS=( doc/html/. )

QA_CONFIG_IMPL_DECL_SKIP=(
	# check fails with any version of gcc. On <14:
	# <artificial>:(.text.startup+0x19): undefined reference to `_rtc'
	_rtc
)

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
}

src_prepare() {
	default

	if [[ ${PV} == *9999 ]]; then
		# fix info file for category directory
		eautoreconf
	else
		elibtoolize
	fi
}

multilib_src_configure() {
	local myconf=(
		--enable-shared
		--disable-static
		$(use_enable "cpu_flags_x86_fma$(usex cpu_flags_x86_fma3 3 4)" fma)
		$(use_enable fortran)
		$(use_enable zbus mips-zbus-timer)
		$(use_enable threads)
		$(use_enable openmp)
	)

	[[ ${PV} == *9999 ]] && myconf+=( --enable-maintainer-mode )

	# --enable-quad-precision is a brittle feature that requires
	# __float128 support from the toolchain, which is lacking on
	# most niche architectures. Bug #770346
	case "${MULTIBUILD_ID}" in
		single-*)
			# altivec, sse, single-paired only work for single
			myconf+=(
				--enable-single
				$(use_enable cpu_flags_ppc_altivec altivec)
				$(use_enable cpu_flags_x86_avx avx)
				$(use_enable cpu_flags_x86_avx2 avx2)
				$(use_enable cpu_flags_x86_sse sse)
				$(use_enable cpu_flags_x86_sse2 sse2)
				$(use_enable cpu_flags_arm_neon neon)
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

		*)
			die "${MULTIBUILD_ID%-*} precision not implemented in this ebuild"
			;;
	esac

	ECONF_SOURCE="${S}" econf "${myconf[@]}" MPICC="$(tc-getCC)"
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
		rm -r "${ED}"/usr/share/doc/${PF}/html || die
	fi

	augment_pc_files() {
		local x
		for x in "${ED}"/usr/$(get_libdir)/pkgconfig/*.pc; do
			local u
			for u in $(usev mpi) $(usev threads) $(usex openmp omp ""); do
				sed -e "s|-lfftw3[flq]\?|&_${u} &|" "${x}" > "${x%.pc}_${u}.pc" || die
			done
		done
	}
	multilib_foreach_abi augment_pc_files

	# fftw uses pkg-config to record its private dependencies
	find "${ED}" -name '*.la' -delete || die
}

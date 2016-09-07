# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools fortran-2 toolchain-funcs

DESCRIPTION="Library of Iterative Solvers for Linear Systems"
HOMEPAGE="http://www.ssisc.org/lis/index.en.html"
SRC_URI="http://www.ssisc.org/lis/dl/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_fma3 cpu_flags_x86_fma4 cpu_flags_x86_sse2 doc fortran mpi openmp quad saamg static-libs"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.6.2-autotools.patch )

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		if ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected compiler"

			if tc-is-clang; then
				ewarn "OpenMP support in sys-devel/clang is provided by sys-libs/libomp,"
				ewarn "which you will need to build ${CATEGORY}/${PN} with USE=\"openmp\""
			fi

			die "need openmp capable compiler"
		fi
		FORTRAN_NEED_OPENMP=1
	fi

	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable fortran) \
		$(use_enable openmp omp) \
		$(use_enable quad) \
		$(use_enable "cpu_flags_x86_fma$(usex cpu_flags_x86_fma3 3 4)" fma) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable saamg) \
		$(use_enable mpi)
}

src_install() {
	use doc && DOCS+=( doc/*.pdf )
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Library of Iterative Solvers for Linear Systems"
HOMEPAGE="https://www.ssisc.org/lis/index.en.html"
SRC_URI="https://www.ssisc.org/lis/dl/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_fma3 cpu_flags_x86_fma4 cpu_flags_x86_sse2 doc fortran mpi openmp quad saamg static-libs"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/${PN}-2.1.3-autotools.patch )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp && FORTRAN_NEED_OPENMP=1
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/927587
	# https://github.com/anishida/lis/issues/37
	filter-lto

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

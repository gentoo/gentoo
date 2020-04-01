# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Library for dense linear algebra over word-size finite fields"
HOMEPAGE="https://linbox-team.github.io/fflas-ffpack/"
SRC_URI="https://github.com/linbox-team/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs openmp cpu_flags_x86_fma3 cpu_flags_x86_fma4 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_avx512f cpu_flags_x86_avx512dq cpu_flags_x86_avx512vl"

# Our autotools patch hacks in PKG_CHECK_MODULES calls.
BDEPEND="virtual/pkgconfig"
DEPEND="virtual/cblas
	virtual/blas
	virtual/lapack
	dev-libs/gmp[cxx]
	=sci-libs/givaro-4.1*"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-2.3.2-blaslapack.patch" )

pkg_pretend() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
}

pkg_setup(){
	tc-export PKG_CONFIG
}

src_prepare(){
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-precompilation \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_fma3 fma) \
		$(use_enable cpu_flags_x86_fma4 fma4) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse41) \
		$(use_enable cpu_flags_x86_sse4_2 sse42) \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable cpu_flags_x86_avx2 avx2) \
		$(use_enable cpu_flags_x86_avx512f avx512f) \
		$(use_enable cpu_flags_x86_avx512dq avx512dq) \
		$(use_enable cpu_flags_x86_avx512vl avx512vl) \
		$(use_enable static-libs static)
}

src_install(){
	default
	find "${ED}" -name '*.la' -delete || die
}

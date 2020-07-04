# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="C++ template library for integer and finite-field linear algebra"
HOMEPAGE="https://linalg.org/"
SRC_URI="https://github.com/linbox-team/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc opencl openmp static-libs cpu_flags_x86_fma3 cpu_flags_x86_fma4 cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2"

BDEPEND="doc? ( app-doc/doxygen )"

# The project README says that gmp, givaro, and blas/lapack are required
# transitively via fflas-ffpack, but that's not true. The build system
# checks for them, and `git grep` shows that they're used directly.
DEPEND="dev-libs/gmp[cxx]
	=sci-libs/givaro-4.1*
	=sci-libs/fflas-ffpack-2.4*
	virtual/cblas
	virtual/lapack
	opencl? ( virtual/opencl )
	dev-libs/ntl:=
	sci-libs/iml
	dev-libs/mpfr:=
	sci-mathematics/flint"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.6.3-pc.patch" )

pkg_pretend() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
}

src_configure() {
	#
	# The --with-all flag includes,
	#
	#   --with-givaro: used for finite fields, integer, etc. (required)
	#   --with-fflas-ffpack:  small field dense linear algebra (required)
	#   --with-ntl: used for finite field, polynomial arithmetic (optional)
	#   --with-iml: used for fast integer/rational linear algebra (optional)
	#   --with-mpfr: not sure, doesn't seem to be used? (optional)
	#   --with-flint: used in algorithms/matrix-blas3 once (optional)
	#   --with-fplll: an fplll interface not directly used (optional)
	#   --with-doxygen: needed with --enable-doc to build them (optional)
	#
	# Some of these could be behind USE flags, but the ./configure output
	# says that they're "not yet mandatory," which makes me think we might
	# be overcomplicating things to make them optional right now.
	#
	# Note: after v1.6.3, we'll need to append --without-archnative to
	# these flags to avoid -march=native being appended by default.
	#
	econf \
		--with-docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-all="${EPREFIX}"/usr \
		--without-fplll \
		$(use_enable doc) \
		$(use_enable openmp) \
		$(use_with opencl ocl) \
		$(use_enable cpu_flags_x86_fma3 fma) \
		$(use_enable cpu_flags_x86_fma4 fma4) \
		$(use_enable cpu_flags_x86_sse3 sse) \
		$(use_enable cpu_flags_x86_sse3 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse41) \
		$(use_enable cpu_flags_x86_sse4_2 sse42) \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable cpu_flags_x86_avx2 avx2) \
		$(use_enable static-libs static)
}

src_install(){
	default
	find "${ED}" -name '*.la' -delete || die
	if use doc; then
		# These files are used for incremental doxygen builds but aren't
		# part of the final output. Check on
		#
		#   https://github.com/linbox-team/linbox/issues/252
		#
		# periodically to see if this is pointless.
		find "${ED}/usr/share/doc/${PF}" -type f -name '*.md5' -delete || die
		find "${ED}/usr/share/doc/${PF}" -type f -name '*.map' -delete || die
	fi
}

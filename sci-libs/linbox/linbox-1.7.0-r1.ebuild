# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="C++ template library for integer and finite-field linear algebra"
HOMEPAGE="https://linalg.org/"
SRC_URI="https://github.com/linbox-team/${PN}/releases/download/v${PV}/${P}.tar.gz"

# I think only macros/libtool.m4 (and COPYING) is GPL-2+; the source
# headers all say LGPL-2.1
LICENSE="GPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc opencl openmp"

BDEPEND="doc? ( app-text/doxygen )"

# The project README says that gmp, givaro, and blas/lapack are required
# transitively via fflas-ffpack, but that's not true. The build system
# checks for them, and `git grep` shows that they're used directly.
DEPEND="dev-libs/gmp[cxx(+)]
	=sci-libs/givaro-4.2*
	=sci-libs/fflas-ffpack-2.5*
	virtual/cblas
	virtual/lapack
	opencl? ( virtual/opencl )
	dev-libs/ntl:=
	sci-libs/iml
	dev-libs/mpfr:=
	sci-mathematics/flint"

# Use mathjax to render inline latex rather than requiring a working latex
# installation to generate bitmaps.
RDEPEND="${DEPEND}
	doc? ( >=dev-libs/mathjax-3 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-hardened-testfails.patch
	"${FILESDIR}"/${PN}-1.7.0-gcc14.patch
)

# The --enable-openmp flag has been removed upstream, but we don't want
# openmp support to disappear after the package has been compiled with
# it, so we retain the USE flag and the toolchain check.
pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	if use doc; then
		# Avoid the need for a working LaTeX installation. MathJax does
		# slow down the browser a bit but it also renders much more
		# nicely than the latex-generated bitmaps would.
		echo "
			USE_MATHJAX = YES
			MATHJAX_VERSION = MathJax_3
			MATHJAX_RELPATH = \"${EPREFIX}/usr/share/mathjax\"
			MATHJAX_EXTENSIONS = ams
		" >> doc/Doxyfile.mod || die
	fi

	eautoreconf
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
	econf \
		--with-docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-all="${EPREFIX}"/usr \
		--without-fplll \
		--without-archnative \
		$(use_enable doc) \
		$(use_with opencl ocl)
}

src_install() {
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

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit flag-o-matic python-any-r1

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="https://www.flintlib.org/"

SRC_URI="https://github.com/flintlib/flint/releases/download/v${PV}/flint-${PV}.tar.xz"
LICENSE="LGPL-2.1+"

# Based off the soname, e.g. /usr/lib64/libflint.so -> libflint.so.15
SLOT="0/19"

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc ntl test"

RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	doc? (
		app-text/texlive-core
		dev-python/sphinx
		dev-tex/latexmk
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	ntl? ( dev-libs/ntl )
"

# NTL is never linked
DEPEND="dev-libs/gmp:=
	dev-libs/mpfr:=
	virtual/cblas"

# Flint 3.x includes arb. We include some version of NTL here if USE=ntl
# is set so that consumers can depend on flint[ntl] to get a usable
# Flint-NTL interface. But otherwise, NTL isn't actually needed at
# runtime, even if Flint was built with USE=ntl.
RDEPEND="${DEPEND}
	ntl? ( dev-libs/ntl )
	!sci-mathematics/arb"

# The rst files are API docs, but they're very low-effort compared to
# the PDF and HTML docs, so we ship them unconditionally and hide only
# the painful parts behind USE=doc.
DOCS="AUTHORS README.md doc/source/*.rst"

PATCHES=(
	"${FILESDIR}/flint-3.3.1-find-cblas.patch"
)

src_configure() {
	# Test failures:
	# * https://bugs.gentoo.org/934463
	# * https://github.com/flintlib/flint/issues/2029
	filter-flags -floop-nest-optimize \
				 -ftree-loop-linear \
				 -floop-strip-mine \
				 -floop-block \
				 -fgraphite-identity

	# ABI needs to be unset because flint uses it internally for
	# an incompatible purpose.
	# --disable-assembly in an attempt to fix bug 946501
	# --enable-debug just adds -g to your CFLAGS
	# --enable-avx2 and --enable-avx512 just add "-mfoo" to CFLAGS
	# --enable-gc affects thread-safety
	local myeconfargs=(
		ABI=""
		--disable-assembly
		--disable-debug
		--with-blas
		--with-gmp
		--with-mpfr
		--without-gc
	)

	# The NTL interface consists of a single header, NTL-interface.h,
	# that is always installed. USE=ntl only determines whether or not
	# the corresponding tests (which actually use NTL) are built and
	# run. As a result, we don't care about USE=ntl without USE=test.
	use test && myeconfargs+=( $(use_with ntl) )
	econf "${myeconfargs[@]}"

	if use doc; then
		# Avoid the "html/_sources" directory that will contain a copy
		# of the rst sources we've already installed, and also avoid
		# installing html/objects.inv.
		HTML_DOCS="doc/build/html/*.html
			doc/build/html/*.js
			doc/build/html/_static"
		DOCS+=" doc/build/latex/Flint.pdf"
	fi
}

src_compile() {
	default

	if use doc; then
		pushd doc
		emake html
		emake latexpdf
		popd
	fi
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="An environment for developing constraint-based applications"
SRC_URI="http://www.gecode.org/download/${P}.tar.gz"
HOMEPAGE="http://www.gecode.org/"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gist gmp test"

RDEPEND="
	gist? (
		|| (
			( dev-qt/qtcore:4 dev-qt/qtgui:4 )
			( dev-qt/qtcore:5 dev-qt/qtgui:5 )
		)
	)
	gmp? (
		|| ( dev-libs/gmp:0 sci-libs/mpir )
		dev-libs/mpfr:0
	)"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

src_configure() {
	 # --disable-examples prevents COMPILING the examples.
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--htmldir="/usr/share/doc/${PF}/html" \
		--disable-examples \
		$(use_enable doc doc-dot) \
		$(use_enable doc doc-tagfile) \
		$(use_enable gist qt) \
		$(use_enable gist) \
		$(use_enable gmp mpfr)
}

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	default

	# The --docdir and --htmldir that we pass to configure don't seem to
	# be respected...
	use doc && dodoc -r doc/html

	if use examples; then
		# The build system supports "examples", but we want to install
		# their source code, not the resulting binaries.
		rm -f examples/CMakeLists.txt \
			|| die 'failed to remove examples/CMakeLists.txt'
		dodoc -r examples
	fi
}

src_test() {
	LD_LIBRARY_PATH="${S}" emake test
	LD_LIBRARY_PATH="${S}" ./test/test || die "test suite failed"
}

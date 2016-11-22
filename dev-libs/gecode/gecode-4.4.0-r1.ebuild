# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools qmake-utils

DESCRIPTION="An environment for developing constraint-based applications"
HOMEPAGE="http://www.gecode.org/"
SRC_URI="http://www.gecode.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gist gmp"

RDEPEND="
	gist? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	gmp? (
		dev-libs/gmp:0
		dev-libs/mpfr:0
	)"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

PATCHES=( "${FILESDIR}/${PN}-4.4.0-no-examples.patch" )

src_prepare() {
	default

	sed -i gecode.m4 \
		-e "s/-ggdb//" -e "s/-O3//" -e "s/-pipe//" \
		-e "/AC_CHECK_PROGS(QMAKE/a AC_SUBST(QMAKE,$(qt4_get_bindir)/qmake)" \
		-e "/AC_CHECK_PROGS(MOC/a AC_SUBST(MOC,$(qt4_get_bindir)/moc)" \
		|| die

	eautoreconf
}

src_configure() {
	 # --disable-examples prevents COMPILING the examples.
	econf \
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

src_test() {
	LD_LIBRARY_PATH="${S}" emake test
	LD_LIBRARY_PATH="${S}" ./test/test || die "test suite failed"
}

src_install() {
	default

	# The --docdir and --htmldir that we pass to configure don't seem to
	# be respected...
	use doc && dodoc -r doc/html/

	if use examples; then
		dodoc -r examples
	fi
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic ninja-utils toolchain-funcs

DESCRIPTION="Tool for polyhedral geometry and combinatorics"
SRC_URI="https://polymake.org/lib/exe/fetch.php/download/${P}-minimal.tar.bz2"
HOMEPAGE="https://polymake.org/"

# polymake itself is GPL-2, but even the minimal tarball bundles a lot
# of other code. I've included everything that turns up with a
#
#   find ./ -name 'LICENSE' -o -name 'COPYING'
#
# in the list below. If any of these bother you, you may want to take a
# closer look at how (or even if) the corresponding code is being used.
LICENSE="BSD GPL-2 GPL-2+ MIT WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="bliss +cdd +flint +normaliz libpolymake lrs nauty ppl singular"

REQUIRED_USE="^^ ( bliss nauty )"

# The "configure" script isn't autotools; it basically exists just to
# exec some other perl script but using the familiar name.
BDEPEND="dev-util/ninja
	dev-lang/perl"

DEPEND="
	libpolymake? ( dev-lang/perl )
	dev-libs/boost:=
	dev-libs/gmp:=
	dev-libs/libxml2:2=
	dev-libs/libxslt:=
	dev-libs/mpfr:=
	sys-libs/readline:=
	bliss? ( sci-libs/bliss:=[gmp] )
	cdd? ( sci-libs/cddlib:= )
	flint? ( sci-mathematics/flint:= )
	lrs? ( >=sci-libs/lrslib-051:=[gmp] )
	nauty? ( sci-mathematics/nauty:= )
	normaliz? ( >=sci-mathematics/normaliz-3.8:= )
	ppl? ( dev-libs/ppl:= )
	singular? ( sci-mathematics/singular:= )"

RDEPEND="${DEPEND}
	dev-lang/perl
	dev-perl/JSON
	dev-perl/Term-ReadLine-Gnu
	dev-perl/TermReadKey
	dev-perl/XML-SAX
	dev-perl/XML-Writer"

# Tests observed failing after upgrade to polymake-4.5. No idea if they
# worked prior to that. Someone who actually understands polymake will
# have to get these working (at least briefly) before we re-enable them.
RESTRICT=test

src_configure() {
	# Without this, the build system tries to use "the highest possible"
	# optimization level and will override what's in your CXXFLAGS.
	export CXXOPT=""

	tc-export CC CXX

	# We need to define BLISS_USE_GMP if bliss was built with gmp support.
	# Therefore we require gmp support on bliss, so that the package
	# manager can prevent rebuilds with changed gmp flag. Yes, this should
	# be append-cppflags; but the build system doesn't respect CPPFLAGS.
	use bliss && append-cxxflags -DBLISS_USE_GMP

	# This isn't an autotools ./configure script, so a lot of things
	# don't work the way you'd expect. We disable openmp unconditionally
	# because it's only supposedly only used for building the bundled
	# libnormaliz (we unbundle it) and for something called to_simplex
	# that I can't find anywhere in the polymake source.
	./configure --prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--libexecdir="${EPREFIX}/usr/$(get_libdir)/polymake" \
		$(usev !libpolymake "--without-callable") \
		--without-java \
		--without-javaview \
		--without-native \
		--without-scip \
		--without-soplex \
		--without-openmp \
		$(use_with bliss bliss "${EPREFIX}/usr") \
		$(use_with cdd cdd "${EPREFIX}/usr") \
		$(use_with flint flint "${EPREFIX}/usr") \
		$(use_with lrs lrs "${EPREFIX}/usr") \
		$(use_with nauty nauty "${EPREFIX}/usr") \
		$(use_with normaliz libnormaliz "${EPREFIX}/usr") \
		$(use_with ppl ppl "${EPREFIX}/usr") \
		$(use_with singular singular "${EPREFIX}/usr") \
		|| die
}

# There is a backwards-compatible Makefile that would call ninja for us
# in src_compile/src_install, but it doesn't handle MAKEOPTS correctly.
src_compile() {
	eninja -C build/Opt
}

src_install() {
	# DESTDIR needs to find its way into the real install script,
	# support/install.pl.
	export DESTDIR="${D}"
	eninja -C build/Opt install
}

src_test() {
	perl/polymake --script run_testcases --emacs-style \
		|| die "test suite failed"
}

pkg_postinst() {
	elog "Additional features for polymake are available through external"
	elog "software such as sci-mathematics/4ti2 and sci-mathematics/topcom."
	elog "After installing new external software run 'polymake --reconfigure'."
}

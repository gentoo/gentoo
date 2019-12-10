# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="A very small C compiler for ix86/amd64"
HOMEPAGE="https://bellard.org/tcc/"
SRC_URI="https://download.savannah.gnu.org/releases/tinycc/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

DEPEND="dev-lang/perl" # doc generation
# Both tendra and tinycc install /usr/bin/tcc
RDEPEND="!dev-lang/tendra"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	# Don't strip
	sed -i -e 's|$(INSTALL) -s|$(INSTALL)|' Makefile || die

	# Fix examples
	sed -i -e '1{
		i#! /usr/bin/tcc -run
		/^#!/d
	}' examples/ex*.c || die
	sed -i -e '1s/$/ -lX11/' examples/ex4.c || die

	# Fix texi2html invocation
	sed -i -e 's/-number//' Makefile || die
	sed -i -e 's/--sections//' Makefile || die

	# Fix compiling tcc with clang
	eapply "${FILESDIR}"/clang.patch

	# Allows using tcc as the system compiler for Gentoo
	eapply "${FILESDIR}"/linker.patch

	eapply_user
}

src_configure() {
	use test && unset CFLAGS LDFLAGS # Tests run with CC=tcc etc, they will fail hard otherwise
					# better fixes welcome, it feels wrong to hack the env like this
	# not autotools, so call configure directly
	./configure --cc="$(tc-getCC)" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc Changelog README TODO VERSION
	#dohtml tcc-doc.html
	exeinto /usr/share/doc/${PF}/examples
	doexe examples/ex*.c
}

src_test() {
	# this is using tcc bits that don't know as-needed etc.
	TCCFLAGS="" emake test
}

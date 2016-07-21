# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="A very small C compiler for ix86/amd64"
HOMEPAGE="http://bellard.org/tcc/"
SRC_URI="http://download.savannah.gnu.org/releases/tinycc/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/perl" # doc generation
# Both tendra and tinycc install /usr/bin/tcc
RDEPEND="!dev-lang/tendra"
IUSE="test"

src_prepare() {
	# Don't strip
	sed -i -e 's|$(INSTALL) -s|$(INSTALL)|' Makefile || die

	# Fix examples
	sed -i -e '1{
		i#! /usr/bin/tcc -run
		/^#!/d
	}' examples/ex*.c || die
	sed -i -e '1s/$/ -lX11/' examples/ex4.c || die

	# fix texi2html invocation
	sed -i -e 's/-number//' Makefile || die
	sed -i -e 's/--sections//' Makefile || die
}

src_configure() {
	use test && unset CFLAGS LDFLAGS # Tests run with CC=tcc etc, they will fail hard otherwise
					# better fixes welcome, it feels wrong to hack the env like this
	# not autotools, so call configure directly
	./configure --cc="$(tc-getCC)" \
                --bindir=/usr/bin \
                --libdir=/usr/$(get_libdir) \
                --tccdir=tcc \
                --includedir=/usr/include \
                --docdir=/usr/share/doc/${PF} \
                --mandir=/usr/share/man
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

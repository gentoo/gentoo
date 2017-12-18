# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="A very small C compiler for ix86/amd64"
HOMEPAGE="http://bellard.org/tcc/"

if [[ $PV == *9999* ]]; then
	EGIT_REPO_URI="http://repo.or.cz/r/tinycc.git"
	KEYWORDS=""
	SRC_URI=""
	scm_eclass=git-r3
else
	KEYWORDS="~amd64 ~x86 ~amd64-linux"
	SRC_URI="http://download.savannah.gnu.org/releases/tinycc/${P}.tar.bz2"
fi

inherit toolchain-funcs ${scm_eclass}

LICENSE="LGPL-2.1"
SLOT="0"

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

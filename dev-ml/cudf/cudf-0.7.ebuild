# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib toolchain-funcs

DESCRIPTION="Library to parse, pretty print, and evaluate CUDF documents"
HOMEPAGE="http://www.mancoosi.org/cudf/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/33593/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?]
	dev-ml/extlib:=
	dev-libs/glib:2
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )
"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit )
	dev-ml/findlib
	dev-lang/perl
"

src_prepare() {
	sed -i \
		-e 's|make|$(MAKE)|g' \
		Makefile || die
	sed -i \
		-e 's|-lncurses|$(shell ${PKG_CONFIG} --libs ncurses glib-2.0)|g' \
		c-lib/Makefile || die
	sed -i \
		-e 's|-lcurses|$(shell ${PKG_CONFIG} --libs ncurses glib-2.0)|g' \
		c-lib/Makefile.variants || die

	tc-export CC PKG_CONFIG

	sed -i \
		-e "s|-lncurses|$( $(tc-getPKG_CONFIG) --libs ncurses)|g" \
		c-lib/cudf.pc.in || die
}

src_compile() {
	emake -j1 all
	emake c-lib
	if use ocamlopt ; then
		emake -j1 opt
		emake c-lib-opt
	fi
}

src_test() {
	emake test
	emake c-lib-test
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
	dodoc BUGS ChangeLog README TODO
}

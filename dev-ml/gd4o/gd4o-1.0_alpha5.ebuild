# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs findlib

MY_P="${P/_alpha/a}"

DESCRIPTION="OCaml interface to the GD graphics library"
HOMEPAGE="https://sourceforge.net/projects/gd4o/"
SRC_URI="mirror://sourceforge/gd4o/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc +ocamlopt"

DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	media-libs/gd
	virtual/jpeg
	sys-libs/zlib
	media-libs/libpng
	media-libs/freetype:2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i 's/CFLAGS =/CFLAGS += -fPIC/' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
	if use ocamlopt ; then
		emake CC="$(tc-getCC)" opt
	fi
	if use doc ; then
		emake docs
	fi
}

src_test() {
	emake test
	if use ocamlopt ; then
		emake test.opt
	fi
}

src_install() {
	findlib_src_install
	dodoc BUGS CHANGES README* TODO doc/manual.txt
	use doc && dohtml -r doc
}

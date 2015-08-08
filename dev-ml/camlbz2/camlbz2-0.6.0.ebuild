# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="OCaml bindings for libbz (AKA, bzip2)"
HOMEPAGE="http://camlbz2.forge.ocamlcore.org/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/72/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="app-arch/bzip2
	>=dev-lang/ocaml-3.12:=[ocamlopt]"
RDEPEND="${DEPEND}"

src_install() {
	findlib_src_preinst
	emake DESTDIR="${OCAMLFIND_DESTDIR}" install
	dodoc ChangeLog README ROADMAP BUGS
	use doc && dohtml doc/*
}

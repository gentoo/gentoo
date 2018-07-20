# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

MY_PV="${PV/_beta/-beta}"
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="Parser and printer for the opam file syntax"
HOMEPAGE="https://github.com/ocaml/opam-file-format"
SRC_URI="https://github.com/ocaml/opam-file-format/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="dev-lang/ocaml:=[ocamlopt?]"
RDEPEND="${DEPEND}"

src_compile() {
	emake byte $(usex ocamlopt native "")
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="$(ocamlc -where)" install
}

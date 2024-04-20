# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A support library for verified Coq parsers produced by Menhir"
HOMEPAGE="http://gallium.inria.fr/~fpottier/menhir/"
SRC_URI="https://gitlab.inria.fr/fpottier/menhir/-/archive/${PV}/menhir-${PV}.tar.bz2"
S="${WORKDIR}"/menhir-${PV}

LICENSE="GPL-2 LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-ml/menhir-${PV}:=
	sci-mathematics/coq:=
"
DEPEND="${RDEPEND}"

src_compile() {
	emake -C ${PN}
	dune build @install --profile release -p ${PN} || die
}

src_install() {
	emake -C ${PN} DESTDIR="${D}" install
	dune_src_install ${PN}

	dodoc ${PN}/CHANGES.md ${PN}/README.md
}

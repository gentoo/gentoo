# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A support library for verified Coq parsers produced by Menhir"
HOMEPAGE="http://gallium.inria.fr/~fpottier/menhir/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.inria.fr/fpottier/menhir.git"
else
	SRC_URI="https://gitlab.inria.fr/fpottier/menhir/-/archive/${PV}/menhir-${PV}.tar.bz2"
	S="${WORKDIR}/menhir-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2 LGPL-2-with-linking-exception"
SLOT="0/${PV}"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-ml/menhir-${PV}:=
	sci-mathematics/coq:=
"
DEPEND="
	${RDEPEND}
"

src_compile() {
	emake -C "${PN}"
	edune build @install --profile release -p "${PN}" || die
}

src_install() {
	emake -C "${PN}" DESTDIR="${D}" install
	dune_src_install

	dodoc "${PN}/CHANGES.md" "${PN}/README.md"
}

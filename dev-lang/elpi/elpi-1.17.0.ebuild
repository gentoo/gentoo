# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Embeddable Lambda Prolog Interpreter in OCaml"
HOMEPAGE="https://github.com/LPCIC/elpi/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LPCIC/${PN}.git"
else
	SRC_URI="https://github.com/LPCIC/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1+"
SLOT="0/${PV}"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-4.08.0:=
	>=dev-ml/menhir-20211230:=
	dev-ml/atd:=
	dev-ml/ppx_deriving:=
	dev-ml/ppxlib:=
	dev-ml/re:=
	dev-ml/stdlib-shims:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-ml/ANSITerminal
		dev-ml/cmdliner
	)
"

DOCS=( AUTHORS.md CHANGES.md ELPI.md INCOMPATIBILITIES.md README.md )

src_install() {
	dune_src_install
	einstalldocs
}

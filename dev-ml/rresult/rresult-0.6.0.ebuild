# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="Result value combinators for OCaml"
HOMEPAGE="https://erratique.ch/software/rresult https://github.com/dbuenzli/rresult"
SRC_URI="https://erratique.ch/software/rresult/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 x86"

RDEPEND="dev-ml/result:="
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/topkg
	dev-ml/ocamlbuild"

src_compile() {
	ocaml pkg/pkg.ml build || die
}

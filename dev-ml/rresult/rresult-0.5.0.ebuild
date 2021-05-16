# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="Result value combinators for OCaml"
HOMEPAGE="https://erratique.ch/software/rresult https://github.com/dbuenzli/rresult"
SRC_URI="https://erratique.ch/software/rresult/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"
IUSE=""

RDEPEND="dev-ml/result:="
DEPEND="${RDEPEND}
	dev-ml/topkg
	dev-ml/ocamlbuild"

src_compile() {
	ocaml pkg/pkg.ml build || die
}

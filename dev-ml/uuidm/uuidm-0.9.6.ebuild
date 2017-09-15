# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib opam

DESCRIPTION="OCaml module implementing 128 bits universally unique identifiers"
HOMEPAGE="http://erratique.ch/software/uuidm"
SRC_URI="http://erratique.ch/software/uuidm/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-ml/cmdliner:="
DEPEND="${RDEPEND}"

src_compile() {
	ocaml pkg/pkg.ml build || die
}

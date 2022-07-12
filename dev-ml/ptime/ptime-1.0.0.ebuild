# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam findlib

DESCRIPTION="POSIX time for OCaml"
HOMEPAGE="
	https://erratique.ch/software/ptime
	https://github.com/dbuenzli/ptime
	https://opam.ocaml.org/packages/ptime/
"
SRC_URI="https://erratique.ch/software/ptime/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-ml/topkg
"
BDEPEND="dev-ml/ocamlbuild"

OPAM_FILE=opam

src_compile() {
	ocaml pkg/pkg.ml build || die
}

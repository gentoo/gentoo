# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit opam

DESCRIPTION="Unicode character properties for OCaml"
HOMEPAGE="https://erratique.ch/software/uucp https://github.com/dbuenzli/uucp"
SRC_URI="https://erratique.ch/software/uucp/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	dev-ml/cmdliner:=
	dev-ml/uunf:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-ml/findlib
	dev-ml/ocamlbuild
	dev-ml/topkg
"

OPAM_FILE="opam"

src_compile() {
	ocaml pkg/pkg.ml build --with-uunf true --with-cmdliner true ||
		die "failed to run the pkg/pkg.ml ocaml compilation script"
}

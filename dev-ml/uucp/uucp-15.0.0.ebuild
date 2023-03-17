# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="Unicode character properties for OCaml"
HOMEPAGE="https://erratique.ch/software/uucp https://github.com/dbuenzli/uucp"
SRC_URI="https://erratique.ch/software/uucp/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="amd64 ~x86"

DEPEND="dev-ml/topkg
	dev-ml/findlib"
RDEPEND="${DEPEND}"
BDEPEND="dev-ml/ocamlbuild"
OPAM_FILE=opam

src_compile() {
	ocaml pkg/pkg.ml build \
		--with-uutf true \
		--with-uunf false \
		--with-cmdliner true \
		|| die
}

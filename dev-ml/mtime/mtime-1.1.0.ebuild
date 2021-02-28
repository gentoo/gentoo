# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils opam

DESCRIPTION="OCaml module to access monotonic wall-clock time"
HOMEPAGE="https://erratique.ch/software/mtime https://github.com/dbuenzli/mtime"
SRC_URI="https://erratique.ch/software/mtime/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="javascript test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/ocaml:=[ocamlopt]
	javascript? ( dev-ml/js_of_ocaml:= )
"
DEPEND="${RDEPEND}
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib"

src_compile() {
	ocaml pkg/pkg.ml build \
		--with-js_of_ocaml $(usex javascript true false) \
		--tests $(usex test true false) \
		|| die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}

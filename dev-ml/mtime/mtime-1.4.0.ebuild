# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edo opam

DESCRIPTION="OCaml module to access monotonic wall-clock time"
HOMEPAGE="https://erratique.ch/software/mtime https://github.com/dbuenzli/mtime"
SRC_URI="https://erratique.ch/software/mtime/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/ocaml:=[ocamlopt]"
DEPEND="${RDEPEND}
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib"

src_compile() {
	edo ocaml pkg/pkg.ml build \
		--tests $(usex test true false)
}

src_test() {
	edo ocaml pkg/pkg.ml test
}

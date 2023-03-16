# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit opam

DESCRIPTION="OCaml module for functional reactive programming"
HOMEPAGE="http://erratique.ch/software/react https://github.com/dbuenzli/react"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dbuenzli/react.git"
else
	SRC_URI="http://erratique.ch/software/react/releases/${P}.tbz"
	KEYWORDS="~amd64 arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ml/findlib
	>=dev-ml/topkg-0.9
"

src_compile() {
	ocaml pkg/pkg.ml build \
		--tests $(usex test 'true' 'false') \
		|| die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}

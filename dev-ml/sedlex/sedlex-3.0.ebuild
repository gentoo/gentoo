# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="An OCaml lexer generator for Unicode"
HOMEPAGE="https://github.com/ocaml-community/sedlex"
SRC_URI="https://github.com/ocaml-community/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/gen:=
	>=dev-ml/ppxlib-0.26:=
	dev-ml/uchar:=
"
RDEPEND="${DEPEND}"

src_compile() {
	ebegin "Building"
	dune build @install --display short --profile release \
		--ignore-promoted-rules
	eend $? || die
}

dune_src_test() {
	ebegin "Testing"
	dune runtest --display short --profile release \
		--ignore-promoted-rules
	eend $? || die
}

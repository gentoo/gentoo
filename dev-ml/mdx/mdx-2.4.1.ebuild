# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Manipulate, parse and generate OCaml compiler version strings"
HOMEPAGE="https://github.com/realworldocaml/mdx"
SRC_URI="https://github.com/realworldocaml/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt test"

RDEPEND="
	dev-ml/astring:=
	dev-ml/camlp-streams:=[ocamlopt?]
	dev-ml/cmdliner:=[ocamlopt?]
	dev-ml/csexp:=[ocamlopt?]
	dev-ml/fmt:=[ocamlopt?]
	dev-ml/logs:=[cli,fmt,ocamlopt?]
	dev-ml/ocaml-version:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	>=dev-ml/result-1.5:=[ocamlopt?]
	"

DEPEND="
	${RDEPEND}
	test? (
		dev-ml/lwt:=[ocamlopt?]
	)
	"

BDEPEND="
	dev-ml/cppo:*
	test? (
		dev-ml/alcotest:*
	)"
RESTRICT="!test? ( test )"

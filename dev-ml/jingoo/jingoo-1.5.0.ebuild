# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="OCaml template engine almost compatible with Jinja2"
HOMEPAGE="https://github.com/tategakibunko/jingoo/"
SRC_URI="https://github.com/tategakibunko/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/menhir:=[ocamlopt?]
	dev-ml/ppx_deriving:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	dev-ml/uucp:=
	dev-ml/uutf:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/ounit2 )"

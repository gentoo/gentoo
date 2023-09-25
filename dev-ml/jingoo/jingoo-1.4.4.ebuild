# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="OCaml template engine almost compatible with Jinja2"
HOMEPAGE="https://github.com/tategakibunko/jingoo/"
SRC_URI="https://github.com/tategakibunko/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/menhir:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppx_deriving:=
	dev-ml/ppxlib:=
	dev-ml/re:=
	dev-ml/uucp:=
	dev-ml/uutf:=
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/ounit2 )"

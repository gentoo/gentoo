# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Parser for ocaml documentation comments"
HOMEPAGE="https://github.com/ocaml-doc/odoc-parser"
SRC_URI="https://github.com/ocaml-doc/odoc-parser/releases/download/${PV}/${P}.tbz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/astring:=
	dev-ml/result:=
	dev-ml/camlp-streams:=
"
DEPEND="${RDEPEND}"
BDEPEND="test? (
	dev-ml/ppx_expect
)"

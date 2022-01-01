# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Feature-full driver for OCaml AST transformers"
HOMEPAGE="https://github.com/janestreet/ppx_driver"
SRC_URI="https://github.com/janestreet/ppx_driver/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/ppxlib:=
		dev-ml/ocaml-migrate-parsetree:=
"
RDEPEND="${DEPEND}"

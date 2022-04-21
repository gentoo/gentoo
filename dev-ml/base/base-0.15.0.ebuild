# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

MYP=${PN}-v${PV}
DESCRIPTION="Standard library for OCaml"
HOMEPAGE="https://github.com/janestreet/base"
SRC_URI="https://ocaml.janestreet.com/ocaml-core/v$(ver_cut 1-2)/files/${MYP}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-ml/sexplib0-0.15.0:=
	dev-ml/dune-configurator:=
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MYP}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Standard library for OCaml"
HOMEPAGE="https://github.com/janestreet/base"
SRC_URI="https://github.com/janestreet/base/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm ~arm64 ~ppc ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.10.0
	=dev-ml/sexplib0-0.15*:=
	dev-ml/dune-configurator:=
"
DEPEND="${RDEPEND}"

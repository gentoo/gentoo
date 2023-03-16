# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Library for automated conversion of OCaml-values to and from S-expressions"
HOMEPAGE="https://github.com/janestreet/sexplib"
SRC_URI="https://github.com/janestreet/sexplib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/parsexp:0/0.15
	dev-ml/base:0/0.15
	=dev-ml/sexplib0-0.15*:=
	dev-ml/num:=
"
DEPEND="${RDEPEND}"

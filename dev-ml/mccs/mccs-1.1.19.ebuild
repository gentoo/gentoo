# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

MY_PV=$(ver_rs 2 '+')

DESCRIPTION="Multi Criteria CUDF Solver"
HOMEPAGE="https://github.com/ocaml-opam/ocaml-mccs"
SRC_URI="https://github.com/ocaml-opam/ocaml-mccs/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/ocaml-${PN}-$(ver_rs 2 '-')

LICENSE="|| ( LGPL-2.1 BSD GPL-3 )"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/cudf:=
	dev-ml/extlib:=
	sci-mathematics/glpk:=
"
DEPEND="${RDEPEND}"

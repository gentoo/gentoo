# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

MY_PV=$(ver_rs 2 '+')

DESCRIPTION="Multi Criteria CUDF Solver"
HOMEPAGE="https://github.com/ocaml-opam/ocaml-mccs"
SRC_URI="https://github.com/ocaml-opam/ocaml-mccs/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/ocaml-${PN}-$(ver_rs 2 '-')

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/cudf:=
	sci-mathematics/glpk:=
"
DEPEND="${RDEPEND}
	test? (
		dev-ml/extlib:=
	)
"

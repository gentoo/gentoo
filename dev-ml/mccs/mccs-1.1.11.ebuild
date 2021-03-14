# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

MY_PV=$(ver_rs 2 '+')

DESCRIPTION="Multi Criteria CUDF Solver"
HOMEPAGE="http://www.i3s.unice.fr/~cpjm/misc/ https://github.com/AltGr/ocaml-mccs/issues"
SRC_URI="https://github.com/AltGr/ocaml-mccs/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
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

S=${WORKDIR}/ocaml-${PN}-$(ver_rs 2 '-')

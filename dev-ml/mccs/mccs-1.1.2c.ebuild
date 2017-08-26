# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator opam

MY_PV=$(replace_version_separator 2 '+')

DESCRIPTION="Multi Criteria CUDF Solver"
HOMEPAGE="http://www.i3s.unice.fr/~cpjm/misc/ https://github.com/AltGr/ocaml-mccs/issues"
SRC_URI="https://github.com/AltGr/ocaml-mccs/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-ml/cudf:=
	sci-mathematics/glpk:=
"
DEPEND="${RDEPEND}
	dev-ml/jbuilder"

S=${WORKDIR}/ocaml-${PN}-$(replace_version_separator 2 '-')

src_compile() {
	jbuilder build -p ${PN} || die
}

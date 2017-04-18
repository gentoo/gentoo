# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PV="${PV/_/+}"
MY_P="${PN}-${PV/_/-}"

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/janestreet/jbuilder"
SRC_URI="https://github.com/janestreet/jbuilder/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc"
IUSE=""

DEPEND="dev-lang/ocaml:="
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/opam
"
OPAMSWITCH="system"

S="${WORKDIR}/${MY_P}"
OPAMROOT="${D}"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		--mandir="${ED}/usr/share/man" \
		${PN}.install || die
}

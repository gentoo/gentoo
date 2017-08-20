# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Folding over record fields"
HOMEPAGE="https://github.com/janestreet/fieldslib"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/base:=
	dev-ml/ppx_driver:=
	dev-ml/ocaml-migrate-parsetree:=
"
DEPEND="${RDEPEND} dev-ml/opam dev-ml/jbuilder"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
}

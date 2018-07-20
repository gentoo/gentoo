# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Helper library for gathering system configuration"
HOMEPAGE="https://github.com/janestreet/configurator"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-lang/ocaml:=
	dev-ml/base:=
	dev-ml/ppx_base:=
	dev-ml/ppx_driver:=
	dev-ml/stdio:=
	dev-ml/ocaml-migrate-parsetree:=
	"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/opam dev-ml/jbuilder"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
}

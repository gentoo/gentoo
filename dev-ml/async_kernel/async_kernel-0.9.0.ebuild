# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Jane Street Capital's asynchronous execution library (core)"
HOMEPAGE="https://github.com/janestreet/async_kernel"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-lang/ocaml-4.02.0:=
	dev-ml/core_kernel:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_jane:=
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

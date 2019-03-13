# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Standard library for OCaml"
HOMEPAGE="https://github.com/janestreet/base"
SRC_URI="https://github.com/janestreet/base/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/sexplib:=
	<dev-ml/sexplib-100
"
DEPEND="${RDEPEND} dev-ml/opam dev-ml/jbuilder"

src_test() {
	jbuilder runtest || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc ROADMAP.md README.org
}

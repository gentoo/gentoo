# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="Path-based dispatching for client- and server-side applications"
HOMEPAGE="https://github.com/inhabitedtype/ocaml-dispatch"
SRC_URI="https://github.com/inhabitedtype/ocaml-dispatch/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-ml/result:=
	dev-lang/ocaml:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/jbuilder
	dev-ml/opam
	test? ( dev-ml/ounit )
"

src_compile() {
	jbuilder build -p dispatch || die
}

oinstall() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		--mandir="${ED}/usr/share/man" \
		${1}.install || die
}

src_install() {
	oinstall dispatch
}

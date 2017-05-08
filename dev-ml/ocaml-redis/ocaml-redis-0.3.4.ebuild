# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="Redis bindings for OCaml"
HOMEPAGE="http://0xffea.github.io/ocaml-redis/"
SRC_URI="https://github.com/0xffea/ocaml-redis/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/ocaml-re:=
	dev-ml/uuidm:=
	dev-ml/lwt:=
"
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	dev-ml/opam
	test? ( dev-ml/ounit )"

src_compile() {
	jbuilder build -p redis || die
}

src_test() {
	jbuilder runtest || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		redis.install || die
}

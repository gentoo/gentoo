# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="Synchronous redis bindings for OCaml"
HOMEPAGE="http://0xffea.github.io/ocaml-redis/ https://github.com/0xffea/ocaml-redis/"
SRC_URI="https://github.com/0xffea/ocaml-redis/archive/${PV}.tar.gz -> ocaml-redis-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/ocaml-redis:=
"
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	dev-ml/opam
	test? ( dev-ml/ounit )"

S=${WORKDIR}/ocaml-redis-${PV}

src_compile() {
	jbuilder build -p redis-sync || die
}

src_test() {
	jbuilder runtest || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		redis-sync.install || die
}

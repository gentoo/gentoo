# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Basic OS interaction for OCaml"
HOMEPAGE="http://erratique.ch/software/bos https://github.com/dbuenzli/bos"
SRC_URI="http://erratique.ch/software/bos/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/rresult:=
	dev-ml/astring:=
	dev-ml/fpath:=
	dev-ml/fmt:=
	dev-ml/logs:=
"
DEPEND="${RDEPEND}
	dev-ml/findlib
	dev-ml/ocamlbuild
	dev-ml/topkg
	test? ( dev-ml/mtime )
"

src_compile() {
	ocaml pkg/pkg.ml build --tests $(usex test true false) || die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
}

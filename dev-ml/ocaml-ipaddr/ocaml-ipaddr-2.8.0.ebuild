# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

DESCRIPTION="OCaml library for manipulation of IP (and MAC) address representations"
HOMEPAGE="https://github.com/mirage/ocaml-ipaddr"
SRC_URI="https://github.com/mirage/ocaml-ipaddr/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="dev-ml/sexplib:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_core:=
	dev-ml/ppx_type_conv:=
	dev-lang/ocaml:=[ocamlopt?]
"
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	dev-ml/findlib
	test? ( dev-ml/ounit )
"

src_install() {
	opam_src_install ipaddr
}

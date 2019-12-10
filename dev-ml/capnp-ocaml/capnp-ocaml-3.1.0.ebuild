# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

DESCRIPTION="OCaml code generator plugin for the Cap'n Proto serialization framework"
HOMEPAGE="https://github.com/pelzlpj/capnp-ocaml"
SRC_URI="https://github.com/pelzlpj/capnp-ocaml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/core_kernel:=
	dev-ml/ocaml-extunix:=
	dev-ml/ocplib-endian:=
	dev-ml/res:=
	dev-ml/ocaml-uint:=
	dev-libs/capnproto:=
"
DEPEND="${RDEPEND}
	test? ( dev-ml/core:= dev-ml/ounit )
	dev-ml/jbuilder
"

src_compile() {
	emake build
}

src_install() {
	opam_src_install capnp
}

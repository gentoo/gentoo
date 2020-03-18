# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib opam

DESCRIPTION="Map OCaml arrays onto C-like structs"
HOMEPAGE="https://github.com/mirage/ocaml-cstruct https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="async +lwt +ppx test"
RESTRICT="!test? ( test )"

RDEPEND="
	async? (
		dev-ml/async_kernel:=
		dev-ml/async_unix:=
		dev-ml/core_kernel:=
	)
	lwt? ( dev-ml/lwt:= )
	ppx? (
		dev-ml/ppx_tools:=
		dev-ml/ocaml-migrate-parsetree:=
		>=dev-ml/ppx_tools_versioned-5.0.1:=
	)
	dev-ml/ocplib-endian:=
	dev-ml/sexplib:=
	dev-ml/type-conv:=
"
DEPEND="
	dev-ml/jbuilder
	test? (
		dev-ml/ounit
		ppx? ( dev-ml/ppx_driver dev-ml/ppx_sexp_conv )
	)
	${RDEPEND}
"

get_targets() {
	local tgt="cstruct,cstruct-unix"
	use lwt && tgt+=",cstruct-lwt"
	use async && tgt+=",cstruct-async"
	use ppx && tgt+=",ppx_cstruct"
	echo "${tgt}"
}

src_compile() {
	jbuilder build -p $(get_targets) || die
}

src_test() {
	jbuilder runtest -p $(get_targets) || die
}

src_install() {
	opam-install cstruct
	opam-install cstruct-unix
	use lwt && opam-install cstruct-lwt
	use async && opam-install cstruct-async
	use ppx && opam-install ppx_cstruct
}

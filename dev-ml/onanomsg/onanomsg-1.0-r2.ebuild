# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam eutils

DESCRIPTION="nanomsg bindings for OCaml"
HOMEPAGE="https://github.com/rgrinberg/onanomsg"
SRC_URI="https://github.com/rgrinberg/onanomsg/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0/${PV}-bigstring"
KEYWORDS="~amd64"
IUSE="+lwt +ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/nanomsg:=
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/ocaml-ctypes:=
	dev-ml/ocaml-ipaddr:=[ocamlopt?]
		dev-ml/sexplib:=
	dev-ml/ppx_deriving:=[ocamlopt?]
	dev-ml/ocaml-containers:=[ocamlopt?]
	dev-ml/ocaml-bigstring:=
	lwt? ( dev-ml/lwt:=[ocamlopt(+)?] )
"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit )
"

src_prepare() {
	epatch "${FILESDIR}/bigstring.patch" \
		"${FILESDIR}/tests.patch" \
		"${FILESDIR}/testrun.patch"
	default
}

src_compile() {
	ocaml pkg/build.ml \
		native=$(usex ocamlopt true false) \
		native-dynlink=$(usex ocamlopt true false) \
		lwt=$(usex lwt true false) \
		ounit=$(usex test true false) \
		|| die
}

src_install() {
	opam_src_install nanomsg
	dodoc CHANGES README.md
}

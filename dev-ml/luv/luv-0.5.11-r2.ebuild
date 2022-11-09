# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Binding to libuv: cross-platform asynchronous I/O"
HOMEPAGE="https://github.com/aantron/luv"
SRC_URI="https://github.com/aantron/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-libs/libuv:=
	dev-ml/ocaml-ctypes:=[ocamlopt?]
	dev-ml/result:=[ocamlopt?]
	dev-ml/integers:=
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gnuconfig
	test? ( dev-ml/alcotest[ocamlopt?] )"

src_prepare() {
	default

	cp "${BROOT}"/usr/share/gnuconfig/config.{guess,sub} src/c/vendor/configure/ || die
}

src_compile() {
	LUV_USE_SYSTEM_LIBUV=yes dune_src_compile
}

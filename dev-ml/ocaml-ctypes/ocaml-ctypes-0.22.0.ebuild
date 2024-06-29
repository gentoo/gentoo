# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=ctypes
inherit dune

DESCRIPTION="Library for binding to C libraries using pure OCaml"
HOMEPAGE="https://github.com/yallop/ocaml-ctypes/"
SRC_URI="https://github.com/yallop/ocaml-ctypes/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-4.03:=
	>=dev-libs/libffi-3.3_rc0:=
	dev-ml/bigarray-compat:=
	dev-ml/integers:=
	dev-ml/dune-configurator:=
"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit2 dev-ml/lwt )"
REQUIRED_USE="ocamlopt"

src_install() {
	dune-install ctypes ctypes-foreign
}

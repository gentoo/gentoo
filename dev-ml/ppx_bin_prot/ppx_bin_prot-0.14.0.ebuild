# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Generation of bin_prot readers and writers from types"
HOMEPAGE="https://github.com/janestreet/ppx_bin_prot"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-ml/base-0.14.0:=
	dev-ml/findlib:=
	>=dev-ml/bin_prot-0.14.0:=
	>=dev-ml/ppx_here-0.14.0:=
	>=dev-ml/ppxlib-0.18.0:=
	>=dev-ml/ocaml-migrate-parsetree-2.0.0:=
	dev-ml/cinaps:=
	dev-ml/sexplib0:=
	"
DEPEND="${RDEPEND}
	test? (
		dev-ml/ppx_jane
		dev-ml/core
		dev-ml/ounit2
		dev-ml/core_bench
	)"

src_prepare() {
	sed -i \
		-e "s:oUnit:ounit2:" \
		test/dune \
		|| die
	default
}

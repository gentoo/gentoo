# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Generation of bin_prot readers and writers from types"
HOMEPAGE="https://github.com/janestreet/ppx_bin_prot"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/bin_prot:${SLOT}
	dev-ml/ppx_here:${SLOT}
	>=dev-ml/ppxlib-0.23.0:=
"
DEPEND="${RDEPEND}
	test? (
		dev-ml/ppx_jane
	)"

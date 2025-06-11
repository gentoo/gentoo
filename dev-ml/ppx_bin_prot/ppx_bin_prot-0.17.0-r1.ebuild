# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Generation of bin_prot readers and writers from types"
HOMEPAGE="https://github.com/janestreet/ppx_bin_prot"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

# Jane Street Minor
JSM=$(ver_cut 1-2)*

RDEPEND="
	>=dev-lang/ocaml-5
	=dev-ml/base-${JSM}:=[ocamlopt?]
	=dev-ml/bin_prot-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_here-${JSM}:=[ocamlopt?]
	=dev-ml/ppxlib_jane-${JSM}:=[ocamlopt?]
	>=dev-ml/ppxlib-0.32.1:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11
	test? (
		dev-ml/ppx_jane
	)
"

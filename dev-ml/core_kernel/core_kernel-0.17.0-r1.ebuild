# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="System-independent part of Core"
HOMEPAGE="https://github.com/janestreet/core_kernel"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

# Wants quickcheck_deprecated for now
RESTRICT="test"

# Jane Street Minor
JSM=$(ver_cut 1-2)*

RDEPEND="
	>=dev-lang/ocaml-5
	=dev-ml/base-${JSM}:=[ocamlopt?]
	=dev-ml/core-${JSM}:=[ocamlopt?]
	=dev-ml/int_repr-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_jane-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_optcomp-${JSM}:=[ocamlopt?]
	=dev-ml/uopt-${JSM}:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"

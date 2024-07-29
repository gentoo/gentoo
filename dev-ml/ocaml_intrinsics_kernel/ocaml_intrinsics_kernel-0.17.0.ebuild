# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Functions to invoke amd64 instructions (such as cmov, min/maxsd, popcnt)"
HOMEPAGE="https://github.com/janestreet/ocaml_intrinsics_kernel/"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

BDEPEND="
	>=dev-ml/dune-3.11
	>=dev-lang/ocaml-4.12
"

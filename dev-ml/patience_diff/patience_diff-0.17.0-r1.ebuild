# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Tool and library implementing patience diff"
HOMEPAGE="https://github.com/janestreet/patience_diff"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

# Jane Street Minor
JSM=$(ver_cut 1-2)*

RDEPEND="
	>=dev-lang/ocaml-5
	=dev-ml/base-${JSM}:=[ocamlopt?]
	=dev-ml/core-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_jane-${JSM}:=[ocamlopt?]
"
DEPEND="${RDEPEND}
	>=dev-ml/dune-3.11"

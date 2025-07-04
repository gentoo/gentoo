# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="S-expression pretty-printer"
HOMEPAGE="https://github.com/janestreet/sexp_pretty"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

# Jane Street Minor
JSM=$(ver_cut 1-2)

RDEPEND="
	>=dev-lang/ocaml-5
	=dev-ml/base-${JSM}*:=[ocamlopt?]
	=dev-ml/ppx_base-${JSM}*:=[ocamlopt?]
	=dev-ml/sexplib-${JSM}*:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"

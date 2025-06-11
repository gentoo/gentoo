# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Standard library for OCaml"
HOMEPAGE="https://github.com/janestreet/base"
SRC_URI="https://github.com/janestreet/base/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

# Jane Street Minor
JSM=$(ver_cut 1-2)

RDEPEND="
	>=dev-lang/ocaml-5
	=dev-ml/sexplib0-${JSM}*:=[ocamlopt?]
	>=dev-ml/dune-configurator-3:=[ocamlopt?]
	=dev-ml/ocaml_intrinsics_kernel-${JSM}*:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"

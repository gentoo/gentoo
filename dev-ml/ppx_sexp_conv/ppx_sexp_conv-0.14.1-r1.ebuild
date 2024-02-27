# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Support Library for type-driven code generators"
HOMEPAGE="https://github.com/janestreet/ppx_sexp_conv"
SRC_URI="https://github.com/janestreet/ppx_sexp_conv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 x86"
IUSE="+ocamlopt"

DEPEND="
	=dev-ml/base-0.14*:=[ocamlopt?]
	dev-ml/findlib:=[ocamlopt?]
	<dev-ml/ppxlib-0.22:=[ocamlopt?]
	dev-ml/ocaml-compiler-libs:=[ocamlopt?]
	>=dev-ml/ocaml-migrate-parsetree-2.0.0:=[ocamlopt?]
	dev-ml/cinaps:=[ocamlopt?]
	dev-ml/sexplib0:=[ocamlopt?]
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-ppxlib-0.18.0.patch )

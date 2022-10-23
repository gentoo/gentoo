# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Generation of accessor and iteration functions for ocaml variant types"
HOMEPAGE="https://github.com/janestreet/ppx_variants_conv"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-ml/base-0.14.0:=
	>=dev-ml/variantslib-0.14.0:=
	>=dev-ml/ppxlib-0.23.0:=
	>=dev-ml/ocaml-compiler-libs-0.11.0:=
	>=dev-ml/ocaml-migrate-parsetree-2.0.0:=
	dev-ml/cinaps:=
	dev-ml/sexplib0:=
"
RDEPEND="${DEPEND}"

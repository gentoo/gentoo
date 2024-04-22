# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Randomized testing framework, designed for compatibility with Base"
HOMEPAGE="https://github.com/janestreet/base_quickcheck"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:=
	dev-ml/fieldslib:=
	dev-ml/ppx_base:${SLOT}
	dev-ml/ppx_fields_conv:${SLOT}
	dev-ml/ppx_let:${SLOT}
	dev-ml/ppx_sexp_value:${SLOT}
	dev-ml/splittable_random:${SLOT}
	>=dev-ml/ppxlib-0.23.0:=
"
RDEPEND="${DEPEND}"

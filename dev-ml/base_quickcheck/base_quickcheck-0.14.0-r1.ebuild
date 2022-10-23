# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Randomized testing framework, designed for compatibility with Base"
HOMEPAGE="https://github.com/janestreet/base_quickcheck"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-ml/base-0.14.0:=
	>=dev-ml/ppx_base-0.14.0:=
	>=dev-ml/ppx_fields_conv-0.14.1:=
	>=dev-ml/ppx_let-0.14.0:=
	>=dev-ml/ppx_sexp_message-0.14.0:=
	>=dev-ml/ppx_sexp_value-0.14.0:=
	dev-ml/splittable_random:=
	>=dev-ml/ppxlib-0.18.0:=
	<dev-ml/ppxlib-0.22.0:=
	>=dev-ml/ocaml-migrate-parsetree-2.0.0:=
	dev-ml/cinaps:=
	dev-ml/sexplib0:=
"
RDEPEND="${DEPEND}"

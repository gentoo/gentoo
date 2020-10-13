# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Binary protocol generator"
HOMEPAGE="https://github.com/janestreet/bin_prot"
SRC_URI="https://github.com/janestreet/bin_prot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/base:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_custom_printf:=
	dev-ml/ppx_fields_conv:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_variants_conv:=
	!dev-ml/bin-prot
"
DEPEND="${RDEPEND}"

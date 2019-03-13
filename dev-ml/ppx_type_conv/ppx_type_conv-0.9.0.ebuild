# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="Support Library for type-driven code generators"
HOMEPAGE="https://github.com/janestreet/ppx_type_conv"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-ml/ppx_driver:=
	dev-ml/ppx_metaquot:=
	dev-ml/ppx_core:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppx_deriving:=
"

RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/jbuilder"

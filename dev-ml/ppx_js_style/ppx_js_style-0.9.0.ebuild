# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="Code style checker for Jane Street Packages"
HOMEPAGE="https://github.com/janestreet/ppx_js_style"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-ml/ppx_core:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_metaquot:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/octavius:=
	"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/jbuilder"

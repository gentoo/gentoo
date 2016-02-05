# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Optional compilation for OCaml"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/ppx_tools:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_here:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_type_conv
	dev-ml/sexplib:=
	dev-ml/ppx_core:="

RDEPEND="${DEPEND}"
DEPEND="${RDEPEND} dev-ml/oasis"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGES.md )

src_prepare() {
	sed -i -e 's/[.]expander/_expander/' _oasis || die
	sed -i -e 's/driver[.]ocamlbuild/driver_ocamlbuild/' _oasis || die
	sed -i -e "s/Executable ppx/Executable ${PN}/" _oasis || die
	rm -f _tags
	oasis setup || die
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit findlib

DESCRIPTION="The transitory OCaml software packager"
HOMEPAGE="http://erratique.ch/software/topkg https://github.com/dbuenzli/topkg"
SRC_URI="https://github.com/dbuenzli/topkg/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-ml/result:=
	dev-lang/ocaml:="
DEPEND="${RDEPEND}
	dev-ml/opam"

src_compile() {
	ocaml pkg/pkg.ml build --pkg-name ${PN} || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md DEVEL.md README.md
}

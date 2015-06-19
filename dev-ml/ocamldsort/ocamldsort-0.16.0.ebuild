# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocamldsort/ocamldsort-0.16.0.ebuild,v 1.5 2014/11/28 19:09:56 aballier Exp $

EAPI=5

DESCRIPTION="A dependency sorter for OCaml source files"
HOMEPAGE="http://dimitri.mutu.net/ocaml.html"
SRC_URI="ftp://quatramaran.ens.fr/pub/ara/ocamldsort/${P}.tar.gz"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=">=dev-lang/ocaml-3.12:=
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )"
RDEPEND="${DEPEND}"

src_compile() {
	emake -j1
}

src_install() {
	emake BINDIR="${ED}/usr/bin" MANDIR="${ED}/usr/share/man" install
	dodoc README THANKS Changes
}

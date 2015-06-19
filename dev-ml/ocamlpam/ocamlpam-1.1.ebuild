# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocamlpam/ocamlpam-1.1.ebuild,v 1.2 2013/08/19 13:51:51 aballier Exp $

EAPI=5

inherit findlib eutils

DESCRIPTION="OCamlPAM - an OCaml library for PAM"
HOMEPAGE="http://sharvil.nanavati.net/projects/ocamlpam/"
SRC_URI="http://sharvil.nanavati.net/projects/${PN}/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]
	sys-libs/pam"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake META
	emake byte
	use ocamlopt && emake opt
}

src_install() {
	findlib_src_preinst
	emake DESTDIR="${OCAMLFIND_DESTDIR}" install
	use ocamlopt && emake DESTDIR="${OCAMLFIND_DESTDIR}" install-opt
	dodoc CHANGES README
}

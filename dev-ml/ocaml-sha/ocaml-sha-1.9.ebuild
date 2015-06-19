# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-sha/ocaml-sha-1.9.ebuild,v 1.1 2013/10/13 07:52:47 aballier Exp $

EAPI=5

inherit findlib vcs-snapshot

DESCRIPTION="A binding for SHA interface code in OCaml"
HOMEPAGE="http://github.com/vincenthz/ocaml-sha"
SRC_URI="http://github.com/vincenthz/ocaml-sha/archive/${PN}-v${PV}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt]"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-v${PV}"

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_install
	dodoc README
}

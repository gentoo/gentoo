# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib vcs-snapshot

DESCRIPTION="A binding for SHA interface code in OCaml"
HOMEPAGE="https://github.com/vincenthz/ocaml-sha"
SRC_URI="https://nodeload.github.com/vincenthz/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt]"
RDEPEND="${DEPEND}"

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_install
	dodoc README
}

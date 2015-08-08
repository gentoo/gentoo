# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

DESCRIPTION="OCaml library to query DNS servers"
HOMEPAGE="http://odns.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt]"
DEPEND="${RDEPEND}"

CLIBS="" # Workaround for bug #422683

src_prepare() {
	sed -i -e "s/version=\"0.2\"/version=\"${PV}\"/" META || die
	epatch "${FILESDIR}/${P}-parmake.patch"
}

src_compile() {
	emake -j1 #453434
}

src_install() {
	findlib_src_preinst
	PREFIX="${D}/usr" emake install
	dodoc AUTHORS README
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

IUSE="+ocamlopt"

DESCRIPTION="A package for ocaml that provides access to mysql databases"
SRC_URI="https://forge.ocamlcore.org/frs/download.php/1500/${P}.tar.gz"
HOMEPAGE="http://ocaml-mysql.forge.ocamlcore.org/"

DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	sys-libs/zlib
	>=virtual/mysql-4.0"

RDEPEND="$DEPEND"

SLOT="0/${PV}"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

src_prepare() {
	has_version '>=dev-lang/ocaml-4.03' && epatch "${FILESDIR}/oc43.patch"
}

src_compile()
{
	emake all
	if use ocamlopt; then
		emake opt
	fi
}

src_install()
{
	findlib_src_preinst
	emake install

	dodoc CHANGES README VERSION || die
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-mysql/ocaml-mysql-1.1.1.ebuild,v 1.5 2014/08/10 20:43:03 slyfox Exp $

EAPI=5

inherit findlib eutils

IUSE="+ocamlopt"

DESCRIPTION="A package for ocaml that provides access to mysql databases"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/870/${P}.tar.gz"
HOMEPAGE="http://ocaml-mysql.forge.ocamlcore.org/"

DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	sys-libs/zlib
	>=virtual/mysql-4.0"

RDEPEND="$DEPEND"

SLOT="0/${PV}"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ppc x86"

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

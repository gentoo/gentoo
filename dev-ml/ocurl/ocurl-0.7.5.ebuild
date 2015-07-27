# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocurl/ocurl-0.7.5.ebuild,v 1.1 2015/07/27 07:44:57 aballier Exp $

EAPI=5

inherit findlib

DESCRIPTION="OCaml interface to the libcurl library"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocurl/"
LICENSE="MIT"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1537/${P}.tar.gz"

SLOT="0/${PV}"
IUSE="examples"

RDEPEND=">=net-misc/curl-7.9.8
	dev-ml/lwt:=
	>=dev-lang/ocaml-3.12:=[ocamlopt]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
KEYWORDS="~amd64 ~x86"

src_compile()
{
	emake -j1 all
}

src_install()
{
	findlib_src_install
	dodoc CHANGES.txt README
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

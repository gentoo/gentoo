# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/camlzip/camlzip-1.05.ebuild,v 1.5 2013/02/12 16:57:17 ago Exp $

EAPI="5"

inherit findlib eutils

IUSE="+ocamlopt"

DESCRIPTION="Compressed file access ML library (ZIP, GZIP and JAR)"
HOMEPAGE="http://forge.ocamlcore.org/projects/camlzip/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1037/${P}.tar.gz"

SLOT="1/${PV}"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

RDEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
		>=sys-libs/zlib-1.1.3"
DEPEND="${RDEPEND}"

src_compile() {
	emake all
	if use ocamlopt; then
		emake allopt
	fi
}

src_install() {
	findlib_src_preinst
	emake DESTDIR="${D}" install-findlib

	dodoc README Changes
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="Compressed file access ML library (ZIP, GZIP and JAR)"
HOMEPAGE="http://forge.ocamlcore.org/projects/camlzip/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1616/${P}.tar.gz"

SLOT="1/${PV}"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ppc x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.05:=[ocamlopt?]
	>=sys-libs/zlib-1.1.3
"
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

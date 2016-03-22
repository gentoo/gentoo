# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit findlib

DESCRIPTION="Compat result type"
HOMEPAGE="https://github.com/janestreet/result"
SRC_URI="https://github.com/janestreet/result/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
DEPEND="${RDEPEND}"

src_compile() {
	emake byte
	use ocamlopt && emake native
}

src_install() {
	findlib_src_install
	dodoc README.md
}

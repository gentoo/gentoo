# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="Compat result type"
HOMEPAGE="https://github.com/janestreet/result"
SRC_URI="https://github.com/janestreet/result/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
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

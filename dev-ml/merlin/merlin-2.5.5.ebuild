# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib vim-plugin

DESCRIPTION="Context sensitive completion for OCaml in Vim and Emacs"
HOMEPAGE="https://github.com/ocaml/merlin"
SRC_URI="https://github.com/ocaml/merlin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml:=
	dev-ml/yojson:=
"
RDEPEND="${DEPEND}
	|| ( app-editors/vim[python] app-editors/gvim[python] )"

src_configure() {
	./configure \
		--prefix "${EPREFIX}/usr" \
		--vimdir "${EPREFIX}//usr/share/vim/vimfiles" \
		|| die
}

src_install() {
	default
}

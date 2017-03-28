# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib toolchain-funcs

DESCRIPTION="Provide the ImageMagick methods to OCaml"
HOMEPAGE="http://www.linux-nantes.org/~fmonnier/OCaml/ImageMagick/"
SRC_URI="http://www.linux-nantes.org/~fmonnier/OCaml/ImageMagick/ImageMagick/${P}.tgz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""
# interactive tests
RESTRICT="test"

DEPEND="media-gfx/imagemagick:=
	dev-lang/ocaml:=[ocamlopt]"
RDEPEND="${DEPEND}"

src_configure() {
	sed -e "s/gcc/$(tc-getCC)/" -i Makefile || die
}

src_install() {
	findlib_src_preinst
	emake find_install
	dodoc README.txt
}

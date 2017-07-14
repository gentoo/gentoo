# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib toolchain-funcs eutils

DESCRIPTION="Provide the ImageMagick methods to OCaml"
HOMEPAGE="http://www.linux-nantes.org/~fmonnier/OCaml/ImageMagick/"
SRC_URI="http://www.linux-nantes.org/~fmonnier/OCaml/ImageMagick/ImageMagick/${P}.tgz
	mirror://gentoo/${P}-imagemagick7.patch.bz2
"

LICENSE="MIT"
SLOT="0/7${PV}"
KEYWORDS="~amd64"
IUSE=""
# interactive tests
RESTRICT="test"

DEPEND=">=media-gfx/imagemagick-7:=
	dev-lang/ocaml:=[ocamlopt]"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${WORKDIR}/${P}-imagemagick7.patch"
	default
}

src_configure() {
	sed -e "s/gcc/$(tc-getCC)/" -i Makefile || die
}

src_install() {
	findlib_src_preinst
	emake find_install
	dodoc README.txt
}

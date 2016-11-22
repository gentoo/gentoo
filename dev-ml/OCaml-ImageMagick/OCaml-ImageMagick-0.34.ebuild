# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Provide the ImageMagick methods to OCaml"
HOMEPAGE="http://www.linux-nantes.org/~fmonnier/OCaml/ImageMagick/"
SRC_URI="http://www.linux-nantes.org/~fmonnier/OCaml/ImageMagick/ImageMagick/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
# interactive tests
RESTRICT="test"

DEPEND="media-gfx/imagemagick:=
	dev-lang/ocaml:=[ocamlopt]"
RDEPEND="${DEPEND}"

src_install() {
	emake OCAML_DIR="${D}/$(ocamlc -where)" install
	dodoc README.txt
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="A command line tool for manipulating PDF files"
HOMEPAGE="https://community.coherentpdf.com/ https://github.com/johnwhitington/cpdf-source/"
SRC_URI="https://github.com/johnwhitington/cpdf-source/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# BSD is only for xmlm.ml
LICENSE="Coherent-Graphics BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-lang/ocaml-4:=[ocamlopt]
	~dev-ml/camlpdf-${PV}:="
DEPEND="${RDEPEND}"

RESTRICT="mirror bindist"

S=${WORKDIR}/${PN}-source-${PV}

src_compile() {
	# parallel make issues
	emake -j1
}

src_install() {
	findlib_src_install

	dobin cpdf
	dodoc Changes README.md cpdfmanual.pdf
	doman cpdf.1

	use doc && dodoc -r doc/cpdf/html
}

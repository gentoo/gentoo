# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib

DESCRIPTION="A command line tool for manipulating PDF files"
HOMEPAGE="https://community.coherentpdf.com/ https://github.com/johnwhitington/cpdf-source/"
SRC_URI="https://github.com/johnwhitington/cpdf-source/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-source-${PV}"

# ISC is only for cpdfxmlm.ml{,i}
LICENSE="AGPL-3 ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND=">=dev-lang/ocaml-4:=[ocamlopt]
	~dev-ml/camlpdf-${PV}:="
DEPEND="${RDEPEND}"

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

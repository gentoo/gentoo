# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}.${PV}"

DESCRIPTION="The ROC RNA Ontology nomenclature and conformer-list development"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/suitename.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/${PN}/${MY_P}.src.tgz"

LICENSE="richardson"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-Wimplicit-function-declaration.patch
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake -f Makefile.linux
}

src_install() {
	dobin suitename
}

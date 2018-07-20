# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Program for converting the DAA and GBI files to ISO"
HOMEPAGE="http://aluigi.org/mytoolz.htm"
SRC_URI="http://aluigi.org/mytoolz/${PN}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/src
PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_configure() {
	tc-export CC
}

src_install() {
	emake PREFIX="${ED%/}"/usr install
	einstalldocs
}

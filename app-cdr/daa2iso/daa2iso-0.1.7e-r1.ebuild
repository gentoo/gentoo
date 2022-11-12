# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Program for converting the DAA and GBI files to ISO"
HOMEPAGE="https://aluigi.org/mytoolz.htm"
SRC_URI="https://aluigi.org/mytoolz/${PN}.zip -> ${P}.zip"
S="${WORKDIR}/src"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_configure() {
	tc-export CC
}

src_install() {
	emake PREFIX="${ED}"/usr install
	einstalldocs
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="FITS file format checker"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/docs/software/ftools/fitsverify/"
SRC_URI="https://heasarc.gsfc.nasa.gov/docs/software/ftools/fitsverify/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sci-libs/cfitsio:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-Wimplicit-function-declaration.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin fitsverify
	einstalldocs
}

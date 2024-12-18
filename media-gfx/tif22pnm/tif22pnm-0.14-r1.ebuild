# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="tif22pnm and png22pnm command-line converters"
HOMEPAGE="http://pts.szit.bme.hu/ https://code.google.com/p/sam2p/"
SRC_URI="https://sam2p.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libpng:=
	media-libs/tiff:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-math.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# bug #944994
	append-cflags -std=gnu17

	default
}

src_install() {
	dobin png22pnm tif22pnm
	einstalldocs
}

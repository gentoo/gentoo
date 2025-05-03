# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tools and a library for creating flame fractal images"
HOMEPAGE="https://flam3.com/"
SRC_URI="https://github.com/scottdraves/flam3/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-libs/libxml2:=
	media-libs/libpng:=
	virtual/jpeg:=
	!<=x11-misc/electricsheep-2.6.8-r2"
DEPEND="${RDEPEND}"

DOCS=( README.txt )

PATCHES=( "${FILESDIR}"/${P}-slibtool.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	docinto examples
	dodoc *.flam3
}

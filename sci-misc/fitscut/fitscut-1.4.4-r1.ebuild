# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Extract cutouts from FITS image files"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	sci-astronomy/wcstools
	sci-libs/cfitsio:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-asinh.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	# gentoo wcs is called wcstools to avoid conflict with wcslib
	sed -e 's/libwcs/wcs/g' \
		-i wcs*.c fitscut.c || die

	# cfitsio/fitsio.h might conflict with host on prefix
	sed -e 's/LIB(wcs,/LIB(wcstools,/' \
		-e 's/-lwcs/-lwcstools/' \
		-e '/cfitsio\/fitsio.h/d' \
		-i configure.in || die

	eautoreconf
}

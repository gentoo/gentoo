# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Extract cutouts from FITS image files"
HOMEPAGE="http://acs.pha.jhu.edu/general/software/fitscut/"
SRC_URI="${HOMEPAGE}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	sci-libs/cfitsio:0=
	sci-astronomy/wcstools:0=
	media-libs/libpng:0=
	virtual/jpeg:0="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-asinh.patch" )

src_prepare() {
	default
	# gentoo wcs is called wcstools to avoid conflict with wcslib
	sed -e 's/libwcs/wcs/g' \
		-i wcs*.c fitscut.c || die
	# cfitsio/fitsio.h might conflict with host on prefix
	sed -e 's/LIB(wcs,/LIB(wcstools,/' \
		-e 's/-lwcs/-lwcstools/' \
		-e '/cfitsio\/fitsio.h/d' \
		configure.in > configure.ac || die
	rm configure.in
	eautoreconf
}

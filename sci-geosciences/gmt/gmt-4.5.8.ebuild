# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils multilib

GSHHS="gshhs-2.2.0"

DESCRIPTION="Powerful map generator"
HOMEPAGE="http://gmt.soest.hawaii.edu/"
SRC_URI="
	mirror://gmt/${P}.tar.bz2
	mirror://gmt/${GSHHS}.tar.bz2
	gmttria? ( mirror://gmt/${P}-non-gpl.tar.bz2 )"

LICENSE="GPL-2 gmttria? ( Artistic )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +gdal gmttria +metric mex +netcdf octave postscript"

RDEPEND="
	!sci-biology/probcons
	gdal? ( sci-libs/gdal )
	netcdf? ( >=sci-libs/netcdf-4.1 )
	octave? ( sci-mathematics/octave )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/GMT${PV}"

# mex can use matlab too which i can't test
REQUIRED_USE="
	mex? ( octave )
"

# hand written make files that are not parallel safe
MAKEOPTS+=" -j1"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.0-no-strip.patch
	"${FILESDIR}"/${PN}-4.5.6-respect-ldflags.patch
	"${FILESDIR}"/${P}-bfr-overflow.patch
	"${FILESDIR}"/${P}-impl-dec.patch
	)

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	mv -f "${WORKDIR}/share/"* "${S}/share/" || die

	tc-export AR RANLIB

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--libdir=/usr/$(get_libdir)/${P}
		--includedir=/usr/include/${P}
		--datadir=/usr/share/${P}
		--docdir=/usr/share/doc/${PF}
		--disable-update
		--disable-matlab
		--disable-xgrid
		--disable-debug
		$(use_enable gdal)
		$(use_enable netcdf)
		$(use_enable octave)
		$(use_enable debug devdebug)
		$(use_enable !metric US)
		$(use_enable postscript eps)
		$(use_enable mex)
		$(use_enable gmttria triangle)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install install-all

	# remove static libs
	find "${ED}/usr/$(get_libdir)" -name '*.a' -exec rm -f {} +

	cat <<- _EOF_ > "${T}/99gmt"
	GMTHOME="${EPREFIX}/usr/share/${P}"
	GMT_SHAREDIR="${EPREFIX}/usr/share/${P}"
	_EOF_
	doenvd "${T}/99gmt"
}

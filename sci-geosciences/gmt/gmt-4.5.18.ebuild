# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

GSHHG="gshhg-gmt-2.3.7"

DESCRIPTION="Powerful map generator"
HOMEPAGE="https://gmt.soest.hawaii.edu/"
SRC_URI="
	mirror://gmt/${P}-src.tar.bz2
	mirror://gmt/${GSHHG}.tar.gz
	gmttria? ( mirror://gmt/${P}-non-gpl-src.tar.bz2 )"

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

# mex can use matlab too which i can't test
REQUIRED_USE="
	mex? ( octave )
"

# hand written make files that are not parallel safe
MAKEOPTS+=" -j1"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.9-no-strip.patch
	"${FILESDIR}"/${PN}-4.5.6-respect-ldflags.patch
	)

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	default

	mkdir "${S}/share/coast" || die
	mv -f "${WORKDIR}/${GSHHG}/"*.nc "${S}/share/coast/" || die
}

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir)/${P} \
		--includedir=/usr/include/${P} \
		--datadir=/usr/share/${P} \
		--docdir=/usr/share/doc/${PF} \
		--disable-update \
		--disable-matlab \
		--disable-xgrid \
		--disable-debug \
		$(use_enable gdal) \
		$(use_enable netcdf) \
		$(use_enable octave) \
		$(use_enable debug devdebug) \
		$(use_enable !metric US) \
		$(use_enable postscript eps) \
		$(use_enable mex) \
		$(use_enable gmttria triangle)
}

src_install() {
	emake DESTDIR="${D}" install-all
	einstalldocs

	docompress -x /usr/share/doc/${PF}/{examples,tutorial}

	# remove static libs
	find "${ED}/usr/$(get_libdir)" -name '*.a' -exec rm -f {} + || die

	cat <<- _EOF_ > "${T}/99gmt"
	GMTHOME="${EPREFIX}/usr/share/${P}"
	GMT_SHAREDIR="${EPREFIX}/usr/share/${P}"
	_EOF_
	doenvd "${T}/99gmt"
}

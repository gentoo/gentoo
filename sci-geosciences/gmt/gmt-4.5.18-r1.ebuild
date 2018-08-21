# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Powerful map generator"
HOMEPAGE="https://gmt.soest.hawaii.edu/"
SRC_URI="
	mirror://gmt/${P}-src.tar.bz2
	gmttria? ( mirror://gmt/${P}-non-gpl-src.tar.bz2 )"

LICENSE="GPL-2+ gmttria? ( Artistic )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples debug +gdal gmttria +gshhg htmldoc +metric mex +netcdf octave postscript tutorial"

RDEPEND="
	!sci-biology/probcons
	gdal? ( sci-libs/gdal )
	gshhg? ( sci-geosciences/gshhg-gmt )
	netcdf? ( >=sci-libs/netcdf-4.1 )
	octave? ( sci-mathematics/octave )"
DEPEND="${RDEPEND}"

# mex can use matlab too which i can't test
REQUIRED_USE="
	mex? ( octave )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.9-no-strip.patch
	"${FILESDIR}"/${PN}-4.5.6-respect-ldflags.patch
	)

src_configure() {
	local myconf=(
		--datadir=/usr/share/${P}
		--includedir=/usr/include/${P}
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
		$(use_with gshhg gshhg-dir /usr/share/gshhg)
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" -j1 install-all
	einstalldocs

	# Remove various documentation
	if ! use doc; then
		rm -rf "${ED}/usr/share/doc/${PF}/pdf" || die
	fi

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -rf "${ED}/usr/share/doc/${PF}/examples" || die
	fi

	if ! use htmldoc; then
		rm -rf "${ED}/usr/share/doc/${PF}/html" || die
	fi

	if use tutorial; then
		docompress -x /usr/share/doc/${PF}/tutorial
	else
		rm -rf "${ED}/usr/share/doc/${PF}/tutorial" || die
	fi

	# remove static libs
	find "${ED}/usr/$(get_libdir)" -name '*.a' -delete || die
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib autotools eutils

GSHHS="gshhs-2.1.1"

DESCRIPTION="Powerful map generator"
HOMEPAGE="http://gmt.soest.hawaii.edu/"
SRC_URI="mirror://gmt/legacy/${P}-src.tar.bz2
	mirror://gmt/legacy/${P}-share.tar.bz2
	mirror://gmt/legacy/${GSHHS}-coast.tar.bz2
	mirror://gmt/legacy/${P}-suppl.tar.bz2
	doc? ( mirror://gmt/legacy/${P}-doc.tar.bz2 )
	gmtfull? ( mirror://gmt/legacy/${GSHHS}-full.tar.bz2 )
	gmthigh? ( mirror://gmt/legacy/${GSHHS}-high.tar.bz2 )
	gmttria? ( mirror://gmt/legacy/${P}-triangle.tar.bz2 )"

LICENSE="GPL-2 gmttria? ( Artistic )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc debug gmtfull gmthigh gmttria +metric mex +netcdf octave postscript"

RDEPEND="
	!sci-biology/probcons
	netcdf? ( >=sci-libs/netcdf-4.1 )
	octave? ( sci-mathematics/octave )
"
DEPEND="${RDEPEND}"

RESTRICT="mirror" # for the gmttria

S="${WORKDIR}/GMT${PV}"

# mex can use matlab too which i can't test
REQUIRED_USE="
	mex? ( octave )
	gmthigh? ( !gmtfull ) gmtfull? ( !gmthigh )
"

# hand written make files that are not parallel safe
MAKEOPTS+=" -j1"

src_prepare() {
	mv -f "${WORKDIR}/share/"* "${S}/share/" || die

	epatch \
		"${FILESDIR}/${PN}-4.5.0-no-strip.patch" \
		"${FILESDIR}/${PN}-4.5.6-respect-ldflags.patch" \
		"${FILESDIR}"/${PN}-4.5.9-unistd.h.patch

	eautoreconf
}

src_configure() {
	# triangle disabled due to non-comercial license
	econf \
		--libdir=/usr/$(get_libdir)/${P} \
		--includedir=/usr/include/${P} \
		--datadir=/usr/share/${P} \
		--docdir=/usr/share/doc/${PF} \
		--disable-update \
		--disable-debug \
		--disable-gdal \
		--disable-matlab \
		--disable-xgrid \
		--enable-shared \
		$(use_enable netcdf) \
		$(use_enable octave) \
		$(use_enable debug devdebug) \
		$(use_enable !metric US) \
		$(use_enable postscript eps) \
		$(use_enable mex) \
		$(use_enable gmttria triangle)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		install-gmt install-data install-suppl install-man

	# remove static libs
	find "${D}/usr/$(get_libdir)" -name '*.a' -exec rm -f {} +

	dodoc README
	use doc && dodoc -r "${S}"/share/doc/${PN}/*

	cat << _EOF_ > "${T}/99gmt"
GMTHOME=${EPREFIX}/usr/share/${P}
GMT_SHAREDIR=${EPREFIX}/usr/share/${P}
_EOF_
	doenvd "${T}/99gmt"
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic toolchain-funcs

DESCRIPTION="X Amateur Station Tracking and Information Reporting"
HOMEPAGE="http://xastir.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="festival gdal geotiff graphicsmagick"

DEPEND=">=x11-libs/motif-2.3:0
	x11-libs/libXt
	x11-libs/libX11
	x11-libs/libXpm
	x11-apps/xfontsel
	dev-libs/libpcre
	net-misc/curl
	sys-libs/db:4.8
	sci-libs/shapelib
	!graphicsmagick? ( media-gfx/imagemagick[-hdri,-q32] )
	graphicsmagick? ( media-gfx/graphicsmagick[-q32] )
	geotiff? ( sci-libs/proj
		sci-libs/libgeotiff
		media-libs/tiff:0 )
	gdal? ( sci-libs/gdal )
	festival? ( app-accessibility/festival )"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix script location (bug #407185)
	epatch "${FILESDIR}"/${P}-scripts.diff

	# fix __FORTIFY_SOURCE warning (bug #337365)
	epatch 	"${FILESDIR}"/${PN}-2.0.4-fortify.diff

	# do not use builtin shapelib if sci-libs/shapelib is not installed
	# instead build without shapelib support (bug #430704)
	epatch "${FILESDIR}"/${P}-no-builtin-shapelib.diff

	# do not filter duplicate flags (see bug 411095)
	epatch "${FILESDIR}"/${PN}-2.0.0-dont-filter-flags.diff

	eautoreconf
}

src_configure() {
	# provide include path to GraphicsMagic for configure stage
	use graphicsmagick && append-cflags -I/usr/include/GraphicsMagick
	econf --with-pcre \
		--with-shapelib \
		--with-dbfawk \
		--without-ax25 \
		--without-gpsman \
		$(use_with !graphicsmagick imagemagick) \
		$(use_with graphicsmagick) \
		$(use_with geotiff libproj) \
		$(use_with geotiff) \
		$(use_with gdal) \
		$(use_with festival)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rf "${D}"/usr/share/doc/${PN}
	dodoc AUTHORS ChangeLog FAQ README README.Contributing \
		README.Getting-Started README.MAPS
}

pkg_postinst() {
	elog "Kernel mode AX.25 and GPSman library not supported."
	elog
	elog "Remember you have to be root to add addditional scripts,"
	elog "maps and other configuration data under /usr/share/xastir."
}

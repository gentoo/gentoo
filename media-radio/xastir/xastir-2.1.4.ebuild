# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic toolchain-funcs

MY_P=${PN/x/X}-Release-${PV}

DESCRIPTION="X Amateur Station Tracking and Information Reporting"
HOMEPAGE="http://xastir.org/"
SRC_URI="https://github.com/Xastir/Xastir/archive/Release-${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="geotiff +graphicsmagick"

DEPEND=">=x11-libs/motif-2.3:0
	x11-libs/libXt
	x11-libs/libX11
	x11-libs/libXpm
	x11-apps/xfontsel
	dev-libs/libpcre
	net-misc/curl
	sys-libs/db:4.8
	sci-libs/shapelib
	!graphicsmagick? ( <media-gfx/imagemagick-7:0=[-hdri,-q32] )
	graphicsmagick? ( media-gfx/graphicsmagick:=[-q32] )
	geotiff? ( sci-libs/proj
		sci-libs/libgeotiff:=
		media-libs/tiff:0 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	eapply_user

	# fix script location (bug #407185)
	eapply  "${FILESDIR}"/${PN}-2.1.2-scripts.diff

	# do not filter duplicate flags (see bug 411095)
	eapply -p0 "${FILESDIR}"/${PN}-2.0.0-dont-filter-flags.diff

	eautoreconf
}

src_configure() {
	# provide include path to GraphicsMagic for configure stage
	use graphicsmagick && append-cflags -I/usr/include/GraphicsMagick
	econf --with-pcre \
		--with-shapelib \
		--with-dbfawk \
		--without-ax25 \
		--without-festival \
		--without-gpsman \
		$(use_with !graphicsmagick imagemagick) \
		$(use_with graphicsmagick) \
		$(use_with geotiff libproj) \
		$(use_with geotiff)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rf "${D}"/usr/share/doc/${PN}
	dodoc AUTHORS ChangeLog CONTRIBUTING.md FAQ README \
		README.Getting-Started README.MAPS README.OSM_maps
}

pkg_postinst() {
	elog "Kernel mode AX.25 and GPSman library not supported."
	elog
	elog "Remember you have to be root to add addditional scripts,"
	elog "maps and other configuration data under /usr/share/xastir."
}

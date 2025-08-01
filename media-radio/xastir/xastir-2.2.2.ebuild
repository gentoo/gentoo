# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools flag-o-matic toolchain-funcs

MY_P=${PN/x/X}-Release-${PV}

DESCRIPTION="X Amateur Station Tracking and Information Reporting"
HOMEPAGE="https://xastir.org/"
SRC_URI="https://github.com/Xastir/Xastir/archive/Release-${PV}.tar.gz
			-> ${P}.tar.gz"

S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="geotiff"

DEPEND=">=x11-libs/motif-2.3:0
	x11-libs/libXt
	x11-libs/libX11
	x11-libs/libXpm
	x11-apps/xfontsel
	dev-libs/libpcre2:=
	net-misc/curl
	sys-libs/db:=
	sci-libs/shapelib:=
	media-gfx/graphicsmagick:=[-q32]
	geotiff? ( sci-libs/proj
		sci-libs/libgeotiff:=
		media-libs/tiff:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user

	# fix script location (bug #407185)
	eapply  "${FILESDIR}"/${PN}-2.1.8-scripts.diff

	# do not filter duplicate flags (see bug #411095)
	eapply -p0 "${FILESDIR}"/${PN}-2.0.0-dont-filter-flags.diff

	eautoreconf
}

src_configure() {
	# provide include path to GraphicsMagic for configure stage
	append-cflags -I/usr/include/GraphicsMagick
	econf \
		--with-shapelib \
		--without-ax25 \
		--without-festival \
		--without-gpsman \
		--without-imagemagick \
		--with-graphicsmagick \
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
		README.MAPS README.OSM_maps
}

pkg_postinst() {
	elog "Kernel mode AX.25 and GPSman library not supported."
	elog
	elog "Remember you have to be root to add addditional scripts,"
	elog "maps and other configuration data under /usr/share/xastir."
}

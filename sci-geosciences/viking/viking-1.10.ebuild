# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg-utils

DESCRIPTION="GPS data editor and analyzer"
HOMEPAGE="https://github.com/viking-gps/viking/"
SRC_URI="
	https://github.com/viking-gps/${PN}/archive/${P}.tar.gz
	doc? ( https://github.com/viking-gps/${PN}/releases/download/${P}/${PN}.pdf )"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +exif libexif geoclue gps +magic nls oauth"

COMMONDEPEND="
	app-arch/bzip2
	>=dev-tcltk/expect-5.45.4
	dev-db/sqlite:3
	dev-libs/expat
	>=dev-libs/glib-2.44:2
	>=dev-libs/json-glib-0.16
	dev-libs/nettle
	net-misc/curl
	sys-libs/zlib
	>=x11-libs/gdk-pixbuf-2.26:2
	>=x11-libs/gtk+-3.22:3
	geoclue? ( >=app-misc/geoclue-2.4.4:2.0 )
	gps? ( >=sci-geosciences/gpsd-3.20 )
	exif? ( libexif? ( media-libs/libexif ) !libexif? ( media-libs/gexiv2 ) )
	magic? ( sys-apps/file )
	oauth? ( net-libs/liboauth )
"
RDEPEND="${COMMONDEPEND}
	sci-geosciences/gpsbabel
"
DEPEND="${COMMONDEPEND}
	app-text/yelp-tools
	dev-util/intltool
	dev-util/gtk-doc
	dev-build/gtk-doc-am
	dev-libs/libxslt
	virtual/pkgconfig
	sys-devel/gettext
"

PATCHES=( "${FILESDIR}/${P}-terraserver.patch" )

src_prepare() {
	default
	eautoreconf

	sed -i -e '/Avoid creator line/isrcdir=test' test/check_gpx.sh || die
}

src_configure() {
	econf \
		--disable-deprecations \
		--with-libcurl \
		--with-expat \
		--enable-google \
		--enable-nettle \
		--enable-terraserver \
		--enable-expedia \
		--enable-openstreetmap \
		--enable-bluemarble \
		--enable-geonames \
		--enable-geocaches \
		--disable-dem24k \
		--disable-mapnik \
		--enable-mbtiles \
		$(use_enable exif geotag) \
		$(use_with libexif ) \
		$(use_enable geoclue) \
		$(use_enable gps realtime-gps-tracking) \
		$(use_enable magic) \
		$(use_enable nls) \
		$(use_enable oauth)
}

src_install() {
	default
	if use doc; then
		dodoc "${DISTDIR}"/${PN}.pdf
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

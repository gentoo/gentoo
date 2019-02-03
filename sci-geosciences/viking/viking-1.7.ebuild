# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="GPS data editor and analyzer"
HOMEPAGE="https://sourceforge.net/projects/viking/"
IUSE="doc +exif libexif geoclue gps +magic mapnik nls oauth sqlite"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	doc? ( mirror://sourceforge/${PN}/${PN}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMONDEPEND="
	app-arch/bzip2
	>=dev-tcltk/expect-5.45.4
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nettle
	net-misc/curl
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	geoclue? ( app-misc/geoclue:2.0 )
	gps? ( >=sci-geosciences/gpsd-2.96 )
	exif? ( libexif? ( media-libs/libexif ) !libexif? ( media-libs/gexiv2 ) )
	magic? ( sys-apps/file )
	mapnik? ( sci-geosciences/mapnik )
	oauth? ( net-libs/liboauth )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${COMMONDEPEND}
	sci-geosciences/gpsbabel
"
DEPEND="${COMMONDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	dev-util/gtk-doc-am
	app-text/rarian
	dev-libs/libxslt
	virtual/pkgconfig
	sys-devel/gettext
"

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
		$(use_enable exif geotag) \
		$(use_with libexif ) \
		$(use_enable geoclue) \
		$(use_enable gps realtime-gps-tracking) \
		$(use_enable magic) \
		$(use_enable mapnik) \
		$(use_enable nls) \
		$(use_enable oauth) \
		$(use_enable sqlite mbtiles )
}

src_install() {
	default
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${PN}.pdf
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

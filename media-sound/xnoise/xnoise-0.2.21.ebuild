# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="A media player for Gtk+ with a slick GUI, great speed and lots of features"
HOMEPAGE="http://www.xnoise-media-player.com/"
SRC_URI="https://www.bitbucket.org/shuerhaaken/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ayatana +lastfm +lyrics"

RDEPEND="
	dev-db/sqlite:3=
	dev-libs/glib:2
	gnome-base/librsvg:2
	media-libs/gstreamer:1.0=
	media-libs/gst-plugins-base:1.0=
	media-libs/libtaginfo:=
	media-plugins/gst-plugins-meta:1.0
	x11-libs/cairo:=
	x11-libs/gtk+:3
	x11-libs/libX11
	ayatana? ( dev-libs/libappindicator:3= )
	lastfm? ( net-libs/libsoup:2.4= )
	lyrics? (
		net-libs/libsoup:2.4=
		dev-libs/libxml2:2=
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.2.21-QA-fix-desktop-file.patch )

src_configure() {
	econf \
		--enable-magnatune \
		--enable-mediakeys \
		--enable-mpris \
		--enable-soundmenu2 \
		$(use_enable ayatana appindicator) \
		$(use_enable lastfm) \
		$(use_enable lyrics lyricwiki) \
		$(use_enable lyrics chartlyrics) \
		$(use_enable lyrics azlyrics)
}

src_install() {
	default
	rm -rf "${ED}"/usr/share/${PN}/license || die

	# no static archives
	find "${D}" -name '*.la' -delete || die
}

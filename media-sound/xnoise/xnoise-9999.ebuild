# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
VALA_MIN_API_VERSION=0.20

inherit fdo-mime gnome2-utils git-2 vala

DESCRIPTION="A media player for Gtk+ with a slick GUI, great speed and lots of
features"
HOMEPAGE="http://www.xnoise-media-player.com/"
EGIT_REPO_URI="https://bitbucket.org/shuerhaaken/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="ayatana +lastfm +lyrics"

RDEPEND="x11-libs/gtk+:3
	>=dev-libs/glib-2.34:2
	gnome-base/librsvg:2
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-plugins/gst-plugins-meta:1.0
	dev-db/sqlite:3
	>=media-libs/libtaginfo-0.2.0
	x11-libs/cairo
	x11-libs/libX11
	ayatana? ( dev-libs/libappindicator:3 )
	lastfm? ( net-libs/libsoup:2.4 )
	lyrics? ( net-libs/libsoup:2.4
		dev-libs/libxml2:2 )"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig
	gnome-base/gnome-common:3
	>=sys-devel/autoconf-2.67:2.5
	sys-devel/gettext"

DOCS=( AUTHORS README )

src_prepare() {
	NOCONFIGURE=yes ./autogen.sh || die
	vala_src_prepare
}

src_configure() {
	econf \
		$(use_enable ayatana appindicator) \
		$(use_enable lyrics lyricwiki) \
		$(use_enable lastfm) \
		--enable-mpris \
		--enable-soundmenu2 \
		--enable-mediakeys \
		$(use_enable lyrics chartlyrics) \
		$(use_enable lyrics azlyrics) \
		--enable-magnatune
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
	rm -rf "${ED}"/usr/share/${PN}/license || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

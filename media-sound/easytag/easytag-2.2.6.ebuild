# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit fdo-mime gnome.org gnome2-utils

DESCRIPTION="GTK+ utility for editing MP2, MP3, MP4, FLAC, Ogg and other media tags"
HOMEPAGE="https://wiki.gnome.org/Apps/EasyTAG"

LICENSE="GPL-2 GPL-2+ LGPL-2 LGPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="flac gtk2 +gtk3 mp3 mp4 opus speex test vorbis wavpack"
REQUIRED_USE="|| ( gtk2 gtk3 )
	opus? ( vorbis )
	speex? ( vorbis )"

RDEPEND=">=dev-libs/glib-2.32:2
	flac? ( >=media-libs/flac-1.3 )
	gtk2? ( >=x11-libs/gtk+-2.24:2 )
	gtk3? ( >=x11-libs/gtk+-3.4:3 )
	mp3? (
		>=media-libs/id3lib-3.8.3-r8
		>=media-libs/libid3tag-0.15.1b-r4
		)
	mp4? ( >=media-libs/taglib-1.9.1[mp4] )
	opus? (
		>=media-libs/opus-1.1
		>=media-libs/opusfile-0.4
		)
	speex? ( >=media-libs/speex-1.2_rc1 )
	vorbis? (
		>=media-libs/libogg-1.3.1
		>=media-libs/libvorbis-1.3.4
		)
	wavpack? ( >=media-sound/wavpack-4.70 )"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.4
	app-text/yelp-tools
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-util/intltool-0.50
	>=sys-devel/gettext-0.18.3.2
	virtual/pkgconfig
	!<dev-util/pkgconfig-0.27
	test? (
		>=dev-util/appdata-tools-0.1.7
		>=dev-util/desktop-file-utils-0.22
		)"

DOCS=( AUTHORS ChangeLog HACKING NEWS README THANKS TODO )

src_prepare() {
	sed -i \
		-e '/^DEPRECATED_CPPFLAGS="/d' \
		-e '/warning_flags/s: -Werror=.*:":' \
		configure || die
}

src_configure() {
	econf \
		$(use_enable test appdata-validate) \
		$(use_enable test tests) \
		$(use_enable mp3) \
		$(use_enable mp3 id3v23) \
		$(use_enable vorbis ogg) \
		$(use_enable opus) \
		$(use_enable speex) \
		$(use_enable flac) \
		$(use_enable mp4) \
		$(use_enable wavpack) \
		$(use_with gtk2)
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; fdo-mime_desktop_database_update; }
pkg_postrm() { gnome2_icon_cache_update; fdo-mime_desktop_database_update; }

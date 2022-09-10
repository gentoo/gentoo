# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="GTK+ utility for editing MP2, MP3, MP4, FLAC, Ogg and other media tags"
HOMEPAGE="https://wiki.gnome.org/Apps/EasyTAG"

LICENSE="GPL-2 GPL-2+ LGPL-2 LGPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="flac mp3 mp4 nautilus opus speex test vorbis wavpack"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	opus? ( vorbis )
	speex? ( vorbis )"

RDEPEND="
	>=dev-libs/glib-2.38:2
	media-libs/libcanberra[gtk3]
	>=x11-libs/gtk+-3.10:3
	flac? ( >=media-libs/flac-1.3:= )
	mp3? (
		>=media-libs/id3lib-3.8.3-r8
		>=media-libs/libid3tag-0.15.1b-r4:=
	)
	mp4? ( >=media-libs/taglib-1.9.1[mp4(+)] )
	nautilus? ( gnome-base/nautilus )
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
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xml-dtd:4.4
	app-text/yelp-tools
	dev-util/glib-utils
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-util/intltool-0.50
	>=sys-devel/gettext-0.18.3.2
	virtual/pkgconfig
	test? (
		dev-libs/appstream-glib
		>=dev-util/desktop-file-utils-0.22
	)"

PATCHES=( "${FILESDIR}"/${P}-ogg-corruption.patch )

src_configure() {
	gnome2_src_configure \
		--disable-Werror \
		$(use_enable test appdata-validate) \
		$(use_enable test tests) \
		$(use_enable mp3) \
		$(use_enable mp3 id3v23) \
		$(use_enable nautilus nautilus-actions) \
		$(use_enable vorbis ogg) \
		$(use_enable opus) \
		$(use_enable speex) \
		$(use_enable flac) \
		$(use_enable mp4) \
		$(use_enable wavpack)
}

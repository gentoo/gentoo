# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ogmrip/ogmrip-1.0.1.ebuild,v 1.2 2015/01/17 22:30:15 pacho Exp $

EAPI=5
GCONF_DEBUG=no

inherit gnome2

DESCRIPTION="Graphical frontend and libraries for ripping DVDs and encoding to AVI/OGM/MKV/MP4"
HOMEPAGE="http://ogmrip.sourceforge.net/"
SRC_URI="mirror://sourceforge/ogmrip/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="aac dbus debug dts gtk libnotify matroska mp3 mp4 nls ogm spell srt static-libs theora vorbis x264 xvid"

COMMON_DEPEND="
	>=dev-libs/glib-2.16:2
	>=app-i18n/enca-1.9
	dev-libs/libxml2
	media-libs/libdvdread
	>=media-video/mplayer-1.0_rc2[dvd,encode,xvid?,dts?,x264?]
	aac? ( >=media-libs/faac-1.24 )
	gtk? (
		>=x11-libs/gtk+-2.12:2
		gnome-base/libglade
		gnome-base/gconf
		dbus? ( dev-libs/dbus-glib )
		libnotify? ( >=x11-libs/libnotify-0.4.3 )
		media-video/mplayer[jpeg]
		)
	matroska? ( media-video/mkvtoolnix )
	mp3? ( media-sound/lame )
	mp4? ( >=media-video/gpac-0.4.2 )
	ogm? ( media-sound/ogmtools )
	spell? ( >=app-text/enchant-1.1.0 )
	srt? ( ||
		(
			( >=app-text/tesseract-2 media-libs/tiff )
			>=app-text/gocr-0.39
			>=app-text/ocrad-0.15
		)
		media-libs/libpng )
	theora? ( media-libs/libtheora )
	vorbis? ( media-sound/vorbis-tools )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs
"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	nls? ( sys-devel/gettext
		dev-util/intltool )
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		$(use_enable debug maintainer-mode) \
		$(use_enable gtk gtk-support) \
		$(use_enable dbus dbus-support) \
		$(use_enable spell enchant-support) \
		$(use_enable ogm ogm-support) \
		$(use_enable matroska mkv-support) \
		$(use_enable mp4 mp4-support) \
		$(use_enable xvid xvid-support) \
		$(use_enable x264 x264-support) \
		$(use_enable theora theora-support) \
		$(use_enable vorbis vorbis-support) \
		$(use_enable mp3 mp3-support) \
		$(use_enable aac aac-support) \
		$(use_enable srt srt-support) \
		$(use_enable static-libs static) \
		$(use_enable libnotify libnotify-support) \
		$(use_enable nls) \
		--with-html-dir=/usr/share/doc/${PF}/html
}

src_install() {
	MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_install #528670
}

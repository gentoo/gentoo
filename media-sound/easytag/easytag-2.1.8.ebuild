# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools gnome.org fdo-mime

DESCRIPTION="GTK+ utility for editing MP2, MP3, MP4, FLAC, Ogg and other media tags"
HOMEPAGE="https://projects.gnome.org/easytag/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="flac mp3 mp4 nls speex vorbis wavpack"

RDEPEND=">=x11-libs/gtk+-2.24:2
	mp3? (
		>=media-libs/id3lib-3.8.3-r7
		media-libs/libid3tag
		)
	flac? (
		media-libs/flac
		media-libs/libvorbis
		)
	mp4? ( media-libs/taglib[mp4] )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	speex? (
		media-libs/speex
		media-libs/libvorbis
		)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-desktop.patch
	epatch "${FILESDIR}"/${P}-werror.patch
	epatch "${FILESDIR}"/${P}-taglib.patch
	epatch "${FILESDIR}"/${P}-docs.patch
	eautoreconf
}

DOCS=( AUTHORS ChangeLog HACKING NEWS README THANKS TODO )

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable mp3) \
		$(use_enable mp3 id3v23) \
		$(use_enable vorbis ogg) \
		$(use_enable speex) \
		$(use_enable flac) \
		$(use_enable mp4) \
		$(use_enable wavpack)
}

pkg_postinst() { fdo-mime_desktop_database_update; }
pkg_postrm() { fdo-mime_desktop_database_update; }

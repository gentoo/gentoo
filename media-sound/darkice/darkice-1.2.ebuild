# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A live audio streamer"
HOMEPAGE="http://www.darkice.org/"
SRC_URI="https://darkice.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 hppa ppc sparc x86"
IUSE="aac aacplus alsa debug jack libsamplerate mp3 opus pulseaudio twolame vorbis"

RDEPEND="aac? ( media-libs/faac )
	aacplus? ( >=media-libs/libaacplus-2.0.0 )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	mp3? ( media-sound/lame )
	opus? ( media-libs/opus )
	pulseaudio? ( media-sound/pulseaudio )
	twolame? ( media-sound/twolame )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}"

# Version 1.2 doesn't check for opus as input codec (bug #593790).
# This is fixed in version 1.3
REQUIRED_USE="|| ( aac aacplus mp3 twolame vorbis )
		|| ( alsa jack pulseaudio )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc47.patch
}

src_configure() {
	econf \
		$(use_with aac faac) \
		$(use_with aacplus) \
		$(use_with alsa) \
		$(use_with debug) \
		$(use_with jack) \
		$(use_with libsamplerate samplerate) \
		$(use_with mp3 lame) \
		$(use_with opus) \
		$(use_with pulseaudio) \
		$(use_with twolame) \
		$(use_with vorbis)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog FAQ NEWS README TODO
}

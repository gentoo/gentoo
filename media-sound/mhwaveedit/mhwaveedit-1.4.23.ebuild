# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mhwaveedit/mhwaveedit-1.4.23.ebuild,v 1.1 2013/08/27 06:02:18 radhermit Exp $

EAPI=5

DESCRIPTION="GTK+ Sound file editor (wav, and a few others.)"
HOMEPAGE="https://gna.org/projects/mhwaveedit"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa jack ladspa libsamplerate nls oss pulseaudio sdl sndfile sox"

RDEPEND="x11-libs/gtk+:2
	x11-libs/pango
	sndfile? ( >=media-libs/libsndfile-1.0.10 )
	sdl? ( >=media-libs/libsdl-1.2.3 )
	alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.98 )
	libsamplerate? ( media-libs/libsamplerate )
	ladspa? ( media-libs/ladspa-sdk )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.10 )
	sox? ( media-sound/sox )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

src_configure() {
	econf \
		--without-arts \
		--without-portaudio \
		$(use_enable nls) \
		$(use_with sndfile libsndfile) \
		$(use_with libsamplerate) \
		$(use_with sdl) \
		$(use_with alsa alsalib) \
		$(use_with oss) \
		$(use_with jack) \
		$(use_with pulseaudio pulse) \
		--without-esound
}

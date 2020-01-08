# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GTK+ Sound file editor (wav, and a few others.)"
HOMEPAGE="https://github.com/magnush/mhwaveedit/"
SRC_URI="https://github.com/magnush/mhwaveedit/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa jack ladspa libsamplerate nls oss pulseaudio sdl sndfile sox"

RDEPEND="
	x11-libs/gtk+:2
	x11-libs/pango
	sndfile? ( media-libs/libsndfile:= )
	sdl? ( media-libs/libsdl:= )
	alsa? ( media-libs/alsa-lib:= )
	jack? ( virtual/jack )
	libsamplerate? ( media-libs/libsamplerate:= )
	ladspa? ( media-libs/ladspa-sdk )
	pulseaudio? ( media-sound/pulseaudio )
	sox? ( media-sound/sox:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.4.23-missing-include.patch )

src_configure() {
	econf \
		--without-arts \
		--without-esound \
		--without-portaudio \
		$(use_enable nls) \
		$(use_with sndfile libsndfile) \
		$(use_with libsamplerate) \
		$(use_with sdl) \
		$(use_with alsa alsalib) \
		$(use_with oss) \
		$(use_with jack) \
		$(use_with pulseaudio pulse)
}

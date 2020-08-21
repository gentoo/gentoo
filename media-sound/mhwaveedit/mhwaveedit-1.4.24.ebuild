# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GTK+ Sound file editor (wav, and a few others.)"
HOMEPAGE="https://github.com/magnush/mhwaveedit/"
SRC_URI="https://github.com/magnush/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa jack ladspa libsamplerate nls oss pulseaudio sdl sndfile sox"

RDEPEND="
	x11-libs/gtk+:2
	x11-libs/pango
	alsa? ( media-libs/alsa-lib:= )
	jack? ( virtual/jack )
	ladspa? ( media-libs/ladspa-sdk )
	libsamplerate? ( media-libs/libsamplerate:= )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl:= )
	sndfile? ( media-libs/libsndfile:= )
	sox? ( media-sound/sox:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.4.23-missing-include.patch )

src_configure() {
	local myeconfargs=(
		--without-arts
		--without-esound
		--without-portaudio
		$(use_with alsa alsalib)
		$(use_with jack)
		$(use_with libsamplerate)
		$(use_enable nls)
		$(use_with oss)
		$(use_with pulseaudio pulse)
		$(use_with sdl)
		$(use_with sndfile libsndfile)
	)
	econf "${myeconfargs[@]}"
}

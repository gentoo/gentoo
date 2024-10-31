# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Music audio files viewer and analiser"
HOMEPAGE="https://www.sonicvisualiser.org/ https://github.com/sonic-visualiser/sonic-visualiser"
SRC_URI="https://code.soundsoftware.ac.uk/attachments/download/2866/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="id3tag jack mad ogg opus osc +portaudio pulseaudio test"

BDEPEND="
	dev-qt/qttest:5
	virtual/pkgconfig
"
RDEPEND="
	app-arch/bzip2
	dev-libs/capnproto:=
	dev-libs/serd
	dev-libs/sord
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/alsa-lib
	media-libs/dssi
	media-libs/ladspa-sdk
	media-libs/liblrdf
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/rubberband
	media-libs/speex
	media-libs/vamp-plugin-sdk
	sci-libs/fftw:3.0=
	id3tag? ( media-libs/libid3tag:= )
	jack? ( virtual/jack )
	mad? ( media-libs/libmad )
	ogg? (
		media-libs/libfishsound
		media-libs/liboggz
	)
	opus? (
		media-libs/libopusenc
		media-libs/opusfile
	)
	osc? ( media-libs/liblo )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
"
DEPEND="${RDEPEND}"

# tests fail without mp3 support
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( jack pulseaudio portaudio )
	test? ( id3tag mad )
"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.1-meson.build.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_use id3tag)
		$(meson_use jack)
		$(meson_use mad)
		$(meson_use ogg)
		$(meson_use opus)
		$(meson_use osc)
		$(meson_use portaudio)
		$(meson_use pulseaudio)
	)
	meson_src_configure
}

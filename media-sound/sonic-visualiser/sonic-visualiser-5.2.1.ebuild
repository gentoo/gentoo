# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Music audio files viewer and analyser"
HOMEPAGE="https://www.sonicvisualiser.org/ https://github.com/sonic-visualiser/sonic-visualiser"
SRC_URI="https://code.soundsoftware.ac.uk/attachments/download/2876/${P}.tar.gz
	https://github.com/${PN}/${PN}/releases/download/sv_v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="id3tag jack mad ogg opus osc +portaudio pulseaudio test"

REQUIRED_USE="
	|| ( jack pulseaudio portaudio )
	test? ( id3tag mad )
"
# tests fail without mp3 support
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2
	dev-libs/capnproto:=
	dev-libs/serd
	dev-libs/sord
	dev-qt/qtbase:6[gui,network,ssl,widgets,xml]
	dev-qt/qtsvg:6
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
	sys-libs/libunwind:=
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
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-meson.build.patch" # downstream
	"${FILESDIR}/${P}-qt-6.9.patch" # bug #966627, svcore git master
	"${FILESDIR}/${P}-qt-6.10.1.patch" # bug #966627, svgui git master
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

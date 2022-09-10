# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg

DESCRIPTION="A lightweight audio player with an emphasis on high audio quality"
HOMEPAGE="http://offog.org/code/potamus/"
SRC_URI="http://offog.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+ao audiofile flac jack mad modplug opus vorbis"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	x11-libs/gtk+:2
	gnome-base/libglade
	media-libs/libsamplerate
	media-video/ffmpeg:0=
	ao? ( media-libs/libao )
	audiofile? ( media-libs/audiofile )
	flac? ( media-libs/flac:= )
	jack? ( virtual/jack )
	mad? ( media-libs/libmad )
	modplug? ( media-libs/libmodplug )
	opus? ( media-libs/opusfile )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable audiofile input-audiofile) \
		$(use_enable flac input-flac) \
		$(use_enable mad input-mad) \
		$(use_enable modplug input-modplug) \
		$(use_enable opus input-opus) \
		$(use_enable vorbis input-vorbis) \
		$(use_enable ao output-ao) \
		$(use_enable jack output-jack)

}

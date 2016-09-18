# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="A lightweight audio player with a simple interface and an emphasis on high audio quality"
HOMEPAGE="http://offog.org/code/potamus/"
SRC_URI="http://offog.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+ao audiofile flac jack libav mad modplug opus vorbis"

RDEPEND="
	x11-libs/gtk+:2
	>=gnome-base/libglade-2
	media-libs/libsamplerate
	ao? ( media-libs/libao )
	audiofile? ( media-libs/audiofile )
	flac? ( media-libs/flac )
	jack? ( media-sound/jack-audio-connection-kit )
	libav? ( media-video/libav:= )
	!libav? ( >=media-video/ffmpeg-2.8:0= )
	mad? ( media-libs/libmad )
	modplug? ( media-libs/libmodplug )
	opus? ( media-libs/opusfile )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/ffmpeg29.patch" )

src_configure() {
	gnome2_src_configure \
		$(use_enable audiofile input-audiofile) \
		$(use_enable flac input-flac) \
		$(use_enable mad input-mad) \
		$(use_enable modplug input-modplug) \
		$(use_enable opus input-opus) \
		$(use_enable vorbis input-vorbis) \
		$(use_enable ao output-ao) \
		$(use_enable jack output-jack)

}

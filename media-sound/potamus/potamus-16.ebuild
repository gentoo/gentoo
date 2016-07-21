# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit gnome2 eutils

DESCRIPTION="a lightweight audio player with a simple interface and an emphasis on high audio quality"
HOMEPAGE="http://offog.org/code/potamus.html"
SRC_URI="http://offog.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="audiofile flac mad modplug opus vorbis +ao jack"

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libglade-2
	media-libs/libsamplerate
	virtual/ffmpeg
	audiofile? ( media-libs/audiofile )
	flac? ( media-libs/flac )
	mad? ( media-libs/libmad )
	modplug? ( media-libs/libmodplug )
	opus? ( media-libs/opusfile )
	vorbis? ( media-libs/libvorbis )
	ao? ( media-libs/libao )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	gnome2_src_prepare
	has_version '>=media-video/ffmpeg-2.8' && epatch "${FILESDIR}/ffmpeg29.patch"
}

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

src_install() {
	default
}

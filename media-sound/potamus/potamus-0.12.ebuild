# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit gnome2

DESCRIPTION="a lightweight audio player with a simple interface and an emphasis on high audio quality"
HOMEPAGE="http://offog.org/code/potamus.html"
SRC_URI="http://offog.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libglade-2
	media-libs/libao
	media-libs/libsamplerate
	media-libs/libvorbis
	media-libs/libmad
	media-libs/audiofile
	media-libs/libmodplug
	virtual/ffmpeg
	media-libs/flac
	media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	gnome2_src_prepare

	sed -i -e \
		's:CODEC_TYPE_AUDIO:AVMEDIA_TYPE_AUDIO:g' \
		src/input-avcodec.c || die
}

src_install() {
	default
}

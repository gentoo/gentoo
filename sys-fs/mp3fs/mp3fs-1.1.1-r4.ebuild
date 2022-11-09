# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Read-only FUSE filesystem which transcodes FLAC audio files to MP3 when read"
HOMEPAGE="https://khenriks.github.com/mp3fs/"
SRC_URI="https://github.com/khenriks/mp3fs/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+flac vorbis"

REQUIRED_USE="|| ( flac vorbis )"
RESTRICT="test"

DEPEND="
	media-libs/libid3tag:=
	media-sound/lame
	sys-fs/fuse:0=
	flac? ( >=media-libs/flac-1.1.4:=[cxx] )
	vorbis? ( >=media-libs/libvorbis-1.3.0 )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with flac) \
		$(use_with vorbis)
}

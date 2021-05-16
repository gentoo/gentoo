# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a read-only FUSE filesystem which transcodes FLAC audio files to MP3 when read"
HOMEPAGE="https://khenriks.github.com/mp3fs/"
SRC_URI="https://github.com/khenriks/mp3fs/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT=test

DEPEND="sys-fs/fuse:0=
	media-libs/libid3tag:=
	media-libs/flac:=
	media-sound/lame
	media-libs/libogg"
RDEPEND="${DEPEND}"

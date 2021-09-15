# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Organizes audio files into directories based on metadata tags"
HOMEPAGE="https://git.zx2c4.com/music-file-organizer/about/"
SRC_URI="https://git.zx2c4.com/music-file-organizer/snapshot/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/icu:=
	media-libs/taglib
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

pkg_postinst() {
	einfo
	einfo "The organizemusic utility recursively moves audio files and audio"
	einfo "directories given as its arguments into the directory specified"
	einfo "by the environment variable MUSICDIR. You may want to set this"
	einfo "environment variable inside your .bashrc. If no MUSICDIR variable"
	einfo "is set, it falls back to \"\$HOME/Music/\"."
	einfo
}

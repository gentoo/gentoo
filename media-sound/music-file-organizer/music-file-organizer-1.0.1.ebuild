# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Organizes audio files into directories based on metadata tags,
along with other metadata utilities."
HOMEPAGE="http://blog.zx2c4.com/813"
SRC_URI="http://git.zx2c4.com/music-file-organizer/snapshot/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/taglib dev-libs/icu:="
DEPEND="${RDEPEND} virtual/pkgconfig"

pkg_postinst() {
	einfo
	einfo "The organizemusic utility recursively moves audio files and audio"
	einfo "directories given as its arguments into the directory specified"
	einfo "by the environment variable MUSICDIR. You may want to set this"
	einfo "environment variable inside your .bashrc. If no MUSICDIR variable"
	einfo "is set, it falls back to \"\$HOME/Music/\"."
	einfo
}

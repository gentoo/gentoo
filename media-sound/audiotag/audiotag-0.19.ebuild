# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A command-line tool for mass tagging/renaming of audio files"
HOMEPAGE="http://github.com/Daenyth/audiotag"
SRC_URI="http://github.com/downloads/Daenyth/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"
IUSE="aac flac mp3 vorbis"

RDEPEND="dev-lang/perl
	flac? ( media-libs/flac )
	vorbis? ( media-sound/vorbis-tools )
	mp3? ( media-libs/id3lib )
	aac? ( || ( media-video/atomicparsley media-video/atomicparsley-wez ) )"
DEPEND=""

src_install() {
	dobin ${PN} || die
	dodoc ChangeLog README
}

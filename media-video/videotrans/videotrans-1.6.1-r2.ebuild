# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A package to convert movies to DVD format and to build DVDs with"
HOMEPAGE="http://videotrans.sourceforge.net/"
SRC_URI="mirror://sourceforge/videotrans/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"

DEPEND="
	media-video/mplayer
	media-video/mjpegtools[png]
	media-video/dvdauthor
	virtual/imagemagick-tools
	media-video/ffmpeg:0
"

RDEPEND="${DEPEND}
	www-client/lynx
	app-shells/bash
	sys-devel/bc
"

DOCS="aspects.txt CHANGES THANKS TODO"

src_prepare() {
	# fixing LDFLAGS usage
	sed -i -e 's|^\(LDFLAGS.*=\).*\( @LIBS@.*\)|\1\2 @LDFLAGS@|' src/Makefile.in

}

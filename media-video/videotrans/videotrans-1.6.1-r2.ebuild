# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A package to convert movies to DVD format and to build DVDs with"
HOMEPAGE="http://videotrans.sourceforge.net/"
SRC_URI="mirror://sourceforge/videotrans/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

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
	app-alternatives/bc
"

DOCS=( aspects.txt CHANGES THANKS TODO )

src_prepare() {
	default
	# fixing LDFLAGS usage
	sed -i -e 's|^\(LDFLAGS.*=\).*\( @LIBS@.*\)|\1\2 @LDFLAGS@|' src/Makefile.in || die

}

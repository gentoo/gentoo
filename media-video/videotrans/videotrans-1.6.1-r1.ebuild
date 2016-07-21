# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A package to convert movies to DVD format and to build DVDs with"
HOMEPAGE="http://videotrans.sourceforge.net/"
SRC_URI="mirror://sourceforge/videotrans/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

IUSE="libav"

DEPEND="
	media-video/mplayer
	media-video/mjpegtools[png]
	media-video/dvdauthor
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	libav? ( media-video/libav )
	!libav? ( media-video/ffmpeg:0 )
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

	# Debian patch to support libav
	use libav && epatch "${FILESDIR}"/${P}-libav.patch
}

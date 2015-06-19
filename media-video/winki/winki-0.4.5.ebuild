# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/winki/winki-0.4.5.ebuild,v 1.6 2014/08/10 21:01:16 slyfox Exp $

EAPI="3"

inherit distutils

DESCRIPTION="A Python frontend to many popular encoding programs"
HOMEPAGE="http://www.winki-the-ripper.de/"
SRC_URI="http://www.winki-the-ripper.de/share/dist/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="css dvd matroska mjpeg mp3 ogg vcd"
DEPEND=">=dev-lang/python-2.3
		>=dev-python/pygtk-2:2
		>=dev-python/pyorbit-2"
RDEPEND="${DEPEND}
		media-video/mplayer[encode]
		media-video/lsdvd
		virtual/ffmpeg
		dvd? ( media-video/dvdauthor )
		mp3? ( media-sound/lame )
		ogg? ( media-sound/ogmtools
			media-sound/vorbis-tools )
		vcd? ( media-video/vcdimager
			media-libs/libdvb )
		mjpeg? ( media-video/mjpegtools )
		matroska? ( media-video/mkvtoolnix )
		css? ( media-libs/libdvdcss )"

DOCS="winkirip/README winkirip/CHANGELOG winkirip/TODO winkirip/AUTHORS"

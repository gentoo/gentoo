# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/winki/winki-0.4.5-r1.ebuild,v 1.1 2015/06/09 01:46:23 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python frontend to many popular encoding programs"
HOMEPAGE="http://www.winki-the-ripper.de/"
SRC_URI="http://www.winki-the-ripper.de/share/dist/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="css dvd matroska mjpeg mp3 ogg vcd"
DEPEND=">=dev-python/pygtk-2:2[${PYTHON_USEDEP}]
	>=dev-python/pyorbit-2[${PYTHON_USEDEP}]"
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

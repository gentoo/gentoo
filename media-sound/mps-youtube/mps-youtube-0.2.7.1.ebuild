# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )
inherit distutils-r1

DESCRIPTION="Terminal-based YouTube player and downloader"
HOMEPAGE="https://github.com/mps-youtube/mps-youtube https://pypi.python.org/pypi/mps-youtube"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/pafy[${PYTHON_USEDEP}]
	virtual/ffmpeg
	|| ( media-video/mplayer media-video/mpv )"

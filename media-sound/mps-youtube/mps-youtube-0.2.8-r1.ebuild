# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mps-youtube/mps-youtube.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Terminal-based YouTube player and downloader"
HOMEPAGE="https://github.com/mps-youtube/mps-youtube https://pypi.org/project/mps-youtube/"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-python/pafy[${PYTHON_USEDEP}]
	virtual/ffmpeg
	|| ( media-video/mpv media-video/mplayer )
"

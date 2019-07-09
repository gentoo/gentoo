# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1 git-r3 gnome2-utils

DESCRIPTION="DevedeNG is a program to create video DVDs and CDs (VCD, sVCD or CVD)"
HOMEPAGE="http://www.rastersoft.com/programas/devede.html"
SRC_URI=""
EGIT_REPO_URI="https://github.com/rastersoft/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="libav"

RDEPEND="dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3
	|| ( media-video/vlc media-video/mpv media-video/mplayer )
	!libav? ( media-video/ffmpeg )
	libav? ( media-video/libav )
	media-video/dvdauthor
	media-video/vcdimager
	virtual/cdrtools
	|| ( app-cdr/brasero kde-apps/k3b )"

DEPEND="${PYTHON_DEPS}"

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

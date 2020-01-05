# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 xdg

DESCRIPTION="DevedeNG is a program to create video DVDs and CDs (VCD, sVCD or CVD)"
HOMEPAGE="http://www.rastersoft.com/programas/devede.html"
SRC_URI="https://gitlab.com/rastersoft/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	|| ( app-cdr/brasero kde-apps/k3b app-cdr/xfburn )"

DEPEND="${PYTHON_DEPS}"

PATCHES=( "${FILESDIR}"/${PN}-4.14.0-no_compress_man.patch )

src_prepare() {
	default

	# Documentation path
	sed -e "s#/usr/share/doc/devedeng#/usr/share/doc/${P}#" \
		-i src/devedeng/configuration_data.py || die
	sed -e "/'doc'/s/devedeng/${P}/" -i setup.py || die

	# Desktop icon
	sed -e "/^Icon/s/.svg$//#" -i data/devede_ng.py.desktop || die
}

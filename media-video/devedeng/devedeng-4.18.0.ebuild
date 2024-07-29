# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 xdg

DESCRIPTION="DevedeNG is a program to create video DVDs and CDs (VCD, sVCD or CVD)"
HOMEPAGE="https://www.rastersoft.com/programas/devede.html"
SRC_URI="https://gitlab.com/rastersoft/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-cdr/cdrtools
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3
	|| ( media-video/vlc media-video/mpv media-video/mplayer )
	media-video/ffmpeg
	media-video/dvdauthor
	media-video/vcdimager
	|| ( app-cdr/brasero kde-apps/k3b app-cdr/xfburn )"

DEPEND="${PYTHON_DEPS}"

# src/unitests only works against system installed devedeng
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-4.14.0-no_compress_man.patch
	"${FILESDIR}"/${PN}-4.17.0-locale_install.patch
)

src_prepare() {
	default

	# Documentation path
	sed -e "s#/usr/share/doc/devedeng#/usr/share/doc/${PF}#" \
		-i src/devedeng/configuration_data.py || die
	sed -e "/'doc'/s/devedeng/${PF}/" -i setup.py || die

	# Desktop icon
	sed -e "/^Icon/s/.svg$//#" -i data/devede_ng.py.desktop || die
}

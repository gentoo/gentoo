# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Wrapper for audio file decoding using FFmpeg or GStreamer"
HOMEPAGE="https://pypi.org/project/audioread/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg gstreamer mad"

RDEPEND="
	ffmpeg? ( media-video/ffmpeg )
	gstreamer? (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		media-libs/gstreamer:1.0
		media-plugins/gst-plugins-meta:1.0
	)
	mad? ( dev-python/pymad )
"

PATCHES=( "${FILESDIR}/${P}-test-deps.patch" ) # git master

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e "/'pytest-runner'/d" -i setup.py || die
}

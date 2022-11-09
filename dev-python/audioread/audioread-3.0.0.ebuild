# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Wrapper for audio file decoding using FFmpeg or GStreamer"
HOMEPAGE="
	https://github.com/beetbox/audioread/
	https://pypi.org/project/audioread/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="ffmpeg gstreamer mad"

RDEPEND="
	ffmpeg? (
		media-video/ffmpeg
	)
	gstreamer? (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		media-libs/gstreamer:1.0
		media-plugins/gst-plugins-meta:1.0
	)
	mad? (
		dev-python/pymad[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/pymad[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

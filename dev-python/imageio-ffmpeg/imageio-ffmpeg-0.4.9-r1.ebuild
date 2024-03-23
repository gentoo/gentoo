# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="FFMPEG wrapper for Python"
HOMEPAGE="
	https://github.com/imageio/imageio-ffmpeg/
	https://pypi.org/project/imageio-ffmpeg/
"
SRC_URI="
	https://github.com/imageio/imageio-ffmpeg/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
PROPERTIES="test_network"
RESTRICT="test"

# ffmpeg is used as an executable during runtime
RDEPEND="
	media-video/ffmpeg:*
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/imageio/imageio-ffmpeg/pull/107
	"${FILESDIR}/${P}-ffmpeg-6.patch"
)

# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="FFMPEG wrapper for Python"
HOMEPAGE="https://pypi.org/project/imageio-ffmpeg/ https://github.com/imageio/imageio-ffmpeg"
SRC_URI="
	https://github.com/imageio/imageio-ffmpeg/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
PROPERTIES="test_network"
RESTRICT="test"

# ffmpeg is used as executable during runtime
RDEPEND="media-video/ffmpeg:*"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/setup_requires/d' -i setup.py || die

	distutils-r1_src_prepare
}

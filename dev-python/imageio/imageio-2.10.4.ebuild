# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python library for reading and writing image data"
HOMEPAGE="https://imageio.github.io/"
SRC_URI="
	https://github.com/imageio/imageio/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	media-libs/freeimage
"
BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Fails because of system installed freeimage
	tests/test_core.py::test_findlib2
	# Needs unpackaged imageio_ffmpeg
	tests/test_ffmpeg.py
	tests/test_ffmpeg_info.py
)

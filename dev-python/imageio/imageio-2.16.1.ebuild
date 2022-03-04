# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
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
# over 50% of tests rely on Internet
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=dev-python/numpy-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-8.3.2[${PYTHON_USEDEP}]
	media-libs/freeimage
"
# requests for fsspec[github]
BDEPEND="
	test? (
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tifffile[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Fails because of system installed freeimage
	tests/test_core.py::test_findlib2
)

EPYTEST_IGNORE=(
	# Needs unpackaged imageio_ffmpeg
	tests/test_ffmpeg.py
	tests/test_ffmpeg_info.py
)

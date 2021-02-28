# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Create thumbnail sheets from video files"
HOMEPAGE="https://github.com/amietn/vcsi"
SRC_URI="https://github.com/amietn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/texttable[${PYTHON_USEDEP}]
	media-fonts/dejavu
	media-video/ffmpeg"

distutils_enable_tests nose

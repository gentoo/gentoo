# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python library for reading and writing image data"
HOMEPAGE="https://imageio.github.io/"
SRC_URI="https://github.com/imageio/imageio/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/freeimage
"
DEPEND="${RDEPEND}"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

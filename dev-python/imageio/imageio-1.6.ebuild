# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5} )

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
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"

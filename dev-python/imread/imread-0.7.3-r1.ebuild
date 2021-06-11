# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Read Image Files"
HOMEPAGE="http://luispedro.org/software/imread/ https://github.com/luispedro/imread"
SRC_URI="https://github.com/luispedro/imread/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/libpng:0
	media-libs/libwebp:0
	media-libs/tiff:0
	"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

distutils_enable_sphinx docs \
	'dev-python/numpydoc'

distutils_enable_tests setup.py

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Doesn't work with python3 yet:
# https://github.com/googlei18n/nototools/issues/472
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Noto fonts support tools and scripts plus web site generation"
HOMEPAGE="https://github.com/googlei18n/nototools"

COMMIT="9c4375f07c9adc00c700c5d252df6a25d7425870"
SRC_URI="https://github.com/googlei18n/nototools/archive/${COMMIT}.tar.gz#/nototools-${COMMIT}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
BDEPEND=""
RDEPEND="${DEPEND}
	media-gfx/scour
	>=dev-python/booleanOperations-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyclipper-1.0.6[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${COMMIT}"

python_test() {
	esetup.py test
}

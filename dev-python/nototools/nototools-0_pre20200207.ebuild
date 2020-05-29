# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Noto fonts support tools and scripts plus web site generation"
HOMEPAGE="https://github.com/googlei18n/nototools"

COMMIT="9731cb825a5c7c7c88c043009f15d4d1e5708df1"
SRC_URI="https://github.com/googlei18n/nototools/archive/${COMMIT}.tar.gz#/nototools-${COMMIT}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	media-gfx/scour
	>=dev-python/booleanOperations-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyclipper-1.0.6[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${COMMIT}"

# Some tests weren't ported to python3 yet
RESTRICT="test"

python_test() {
	esetup.py test
}

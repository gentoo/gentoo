# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Doesn't work with python3 yet:
# https://github.com/googlei18n/nototools/issues/472
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Noto fonts support tools and scripts plus web site generation"
HOMEPAGE="https://github.com/googlei18n/nototools"

COMMIT="40aa4936022295cf851bb62f09a070f63fc8f5ae"
SRC_URI="https://github.com/googlei18n/nototools/archive/${COMMIT}.tar.gz#/nototools-${COMMIT}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/backports-os[${PYTHON_USEDEP}]
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/fonttools[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${COMMIT}"

python_test() {
	esetup.py test
}

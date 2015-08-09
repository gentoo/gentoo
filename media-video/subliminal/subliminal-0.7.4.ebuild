# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
# setup.py declares support for python3.3, but it does not work
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library to search and download subtitles"
HOMEPAGE="http://subliminal.readthedocs.org https://github.com/Diaoul/subliminal https://pypi.python.org/pypi/subliminal"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/beautifulsoup-4.3.2:4[${PYTHON_USEDEP}]
	>=dev-python/guessit-0.6.2[${PYTHON_USEDEP}]
	<dev-python/guessit-0.7[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/enzyme-0.4[${PYTHON_USEDEP}]
	>=dev-python/html5lib-0.99[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/babelfish-0.4.0[${PYTHON_USEDEP}]
	<dev-python/babelfish-0.5[${PYTHON_USEDEP}]
	>=dev-python/charade-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/pysrt-0.5.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
# tests need network
RESTRICT="test"

python_test() {
	esetup.py test
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Diaoul/subliminal.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit distutils-r1

DESCRIPTION="Python library to search and download subtitles"
HOMEPAGE="http://subliminal.readthedocs.org https://github.com/Diaoul/subliminal https://pypi.python.org/pypi/subliminal"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/babelfish-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.2.0:4[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/click-4.0[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/enzyme-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/guessit-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/pysrt-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.0.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-1.6.1[${PYTHON_USEDEP}]
	)
	dev-python/setuptools[${PYTHON_USEDEP}]
"
# tests need network
RESTRICT="test"

python_test() {
	esetup.py test
}

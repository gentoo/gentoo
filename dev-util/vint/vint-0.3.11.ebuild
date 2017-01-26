# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Lint tool for Vim script language"
HOMEPAGE="https://github.com/Kuniwak/vint https://pypi.python.org/pypi/vim-vint/"
SRC_URI="https://github.com/Kuniwak/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	>=dev-python/ansicolor-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	virtual/python-pathlib[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.6.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-1.8.1[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]' python2_7)
	)
"

python_test() {
	py.test -v || die "Test suite failed with ${EPYTHON}"
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Format-agnostic tabular dataset library"
HOMEPAGE="https://pypi.org/project/tablib/ https://github.com/jazzband/tablib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/markuppy[${PYTHON_USEDEP}]
		dev-python/odfpy[${PYTHON_USEDEP}]
		dev-python/openpyxl[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/xlrd[${PYTHON_USEDEP}]
		dev-python/xlwt[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	sed -i -e 's:addopts = -rsxX --showlocals --tb=native --cov=tablib --cov=tests --cov-report xml --cov-report term --cov-report html:addopts = -rsxX --showlocals --tb=native:' pytest.ini || die
	distutils-r1_src_prepare
}

distutils_enable_tests pytest

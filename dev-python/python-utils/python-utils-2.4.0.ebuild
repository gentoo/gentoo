# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} pypy3)

inherit distutils-r1

DESCRIPTION="Collection of small Python functions & classes"
HOMEPAGE="https://pypi.org/project/python-utils/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	find . -name '__pycache__' -prune -exec rm -rf {} \; || die "Cleaning __pycache__ failed"
	find . -name '*.pyc' -exec rm -f {} \; || die "Cleaning *.pyc failed"
	sed -i -e '/--cov/d' -e '/--pep8/d' -e '/--flakes/d' pytest.ini || die
	sed -i -e 's/+ pytest-runner//' setup.py || die
	distutils-r1_python_prepare_all
}

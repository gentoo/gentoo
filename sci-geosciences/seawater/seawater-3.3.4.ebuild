# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Calculate properties of sea water. Similar to SEAWATER 3.2 for MATLAB"
HOMEPAGE="https://pypi.org/project/seawater/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" # seems there are files missing

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/oct2py[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
	)"

python_test() {
	esetup.py test
}

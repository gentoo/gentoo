# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} pypy )
inherit eutils distutils-r1

DESCRIPTION="Extended pickling support for Python objects"
HOMEPAGE="https://pypi.org/project/cloudpickle/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

IUSE="test"
RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
	  dev-python/mock[${PYTHON_USEDEP}]
	  dev-python/pytest[${PYTHON_USEDEP}] )"

RESTRICT="test"

python_test() {
	PYTHONPATH='.:tests' py.test || die
}

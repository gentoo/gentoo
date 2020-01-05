# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

MY_PN="pydocstyle"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python docstring style checker"
HOMEPAGE="https://pypi.python.org/pypi/pep257"
SRC_URI="https://github.com/PyCQA/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	distutils-r1_python_install_all
}

python_test() {
	esetup.py test
}

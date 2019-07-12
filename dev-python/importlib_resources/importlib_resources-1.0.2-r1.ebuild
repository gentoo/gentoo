# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is a backport of Python 3.7's importlib.resources
PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6}} )

inherit distutils-r1

DESCRIPTION="Read resources from Python packages"
HOMEPAGE="https://importlib-resources.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' -2)
	virtual/python-typing[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( ${RDEPEND} )
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# https://gitlab.com/python-devs/importlib_resources/issues/71
PATCHES=( "${FILESDIR}/${P}-skip-wheel.patch" )

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "tests failed with ${EPYTHON}"
}

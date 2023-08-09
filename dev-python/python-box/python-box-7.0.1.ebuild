# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

MY_P=Box-${PV}
DESCRIPTION="Python dictionaries with advanced dot notation access"
HOMEPAGE="
	https://github.com/cdgriffith/Box/
	https://pypi.org/project/python-box/
"
SRC_URI="
	https://github.com/cdgriffith/Box/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.8 3.9 3.10)
	dev-python/tomli-w[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# looks like broken tests
		# https://github.com/cdgriffith/Box/issues/257
		test/test_box.py::TestBox::test_box_kwargs_should_not_be_included
		test/test_box.py::TestBox::test_box_namespace
	)

	rm -rf box || die
	epytest
}

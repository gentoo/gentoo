# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="https://gitlab.com/pycqa/flake8 https://pypi.org/project/flake8/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="test"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND="
	>=dev-python/entrypoints-0.3[${PYTHON_USEDEP}]
	<dev-python/entrypoints-0.4[${PYTHON_USEDEP}]
	>=dev-python/pyflakes-2.1.0[${PYTHON_USEDEP}]
	<dev-python/pyflakes-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.5.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.6.0[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/configparser[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/functools32[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/functools32[${PYTHON_USEDEP}]' -2)
	!dev-python/pep8[${PYTHON_USEDEP}]
"
PDEPEND="
	>=dev-python/mccabe-0.6.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${PDEPEND}
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# don't treat warnings as errors when running tests
	sed -r -i '/^[[:space:]]*error[[:space:]]*$/ d' pytest.ini || die

	distutils-r1_python_prepare_all
}

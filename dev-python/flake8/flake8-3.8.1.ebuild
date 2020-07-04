# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="https://gitlab.com/pycqa/flake8 https://pypi.org/project/flake8/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND="
	>=dev-python/pyflakes-2.2.0[${PYTHON_USEDEP}]
	<dev-python/pyflakes-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.6.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.7.0[${PYTHON_USEDEP}]
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
"
PDEPEND="
	>=dev-python/mccabe-0.6.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		${PDEPEND}
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# Sphinx and friends are not keyworded for all arches, repoman complains
#distutils_enable_sphinx docs/source dev-python/sphinx-prompt dev-python/sphinx_rtd_theme

python_prepare_all() {
	# don't treat warnings as errors when running tests
	sed -r -i '/^[[:space:]]*error[[:space:]]*$/ d' pytest.ini || die

	distutils-r1_python_prepare_all
}

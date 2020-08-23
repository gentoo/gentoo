# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python docstring style checker"
HOMEPAGE="https://github.com/PyCQA/pydocstyle/"
SRC_URI="https://github.com/PyCQA/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/snowballstemmer[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/pytest-pep8[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-python/tox[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
# Requires network to lookup github issues
#distutils_enable_sphinx docs dev-python/sphinx_rtd_theme dev-python/sphinxcontrib-issuetracker

python_prepare_all() {
	# These tests call pip.
	# pip install fails because we are not allowed to do that inside an ebuild.
	rm "${S}/src/tests/test_integration.py" || die

	distutils-r1_python_prepare_all
}

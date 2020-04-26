# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python docstring style checker"
HOMEPAGE="https://github.com/PyCQA/pydocstyle/"
SRC_URI="https://github.com/PyCQA/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/snowballstemmer[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pytest-pep8[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme \
	dev-python/sphinxcontrib-issuetracker

src_prepare() {
	default

	# These tests call pip.
	# pip install fails because we are not allowed to do that inside an ebuild.
	rm "${S}"/src/tests/test_integration.py || die
}

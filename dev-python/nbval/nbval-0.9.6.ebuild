# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="A py.test plugin to validate Jupyter notebooks"
HOMEPAGE="https://github.com/computationalmodelling/nbval"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-cov[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-python/sympy[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		--deselect tests/test_ignore.py::test_conf_ignore_stderr
		--deselect tests/test_timeouts.py::test_timeouts
	)

	pytest -vv "${deselect[@]}" || die "Tests failed with ${EPYTHON}"
}

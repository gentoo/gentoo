# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="pytest plugin for coverage reporting"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-cov/
	https://pypi.org/project/pytest-cov/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/py-1.4.22[${PYTHON_USEDEP}]
	>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
	>=dev-python/coverage-6.4.4-r1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/fields[${PYTHON_USEDEP}]
		>=dev-python/process-tests-2.0.2[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.0-pytest-xdist-2.5.0.patch
)

distutils_enable_sphinx docs \
	dev-python/sphinx-py3doc-enhanced-theme
distutils_enable_tests pytest

python_test() {
	# NB: disabling all plugins speeds tests up a lot
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_cov.plugin,xdist.plugin,xdist.looponfail

	local EPYTEST_DESELECT=(
		# attempts to install packages via pip (network)
		tests/test_pytest_cov.py::test_dist_missing_data
		# TODO: pytest-cov.pth breaks importing coverage
		# https://bugs.gentoo.org/889886
		tests/test_pytest_cov.py::test_append_coverage_subprocess
		tests/test_pytest_cov.py::test_central_subprocess_change_cwd
		tests/test_pytest_cov.py::test_central_subprocess_change_cwd_with_pythonpath
		tests/test_pytest_cov.py::test_central_subprocess
		tests/test_pytest_cov.py::test_dist_subprocess_collocated
		tests/test_pytest_cov.py::test_dist_subprocess_not_collocated
		tests/test_pytest_cov.py::test_subprocess_with_path_aliasing
		# TODO
		tests/test_pytest_cov.py::test_contexts
		tests/test_pytest_cov.py::test_cleanup_on_sigterm
		tests/test_pytest_cov.py::test_cleanup_on_sigterm_sig_dfl
		tests/test_pytest_cov.py::test_cleanup_on_sigterm_sig_dfl_sigint
		tests/test_pytest_cov.py::test_cleanup_on_sigterm_sig_ign
	)

	epytest -n "$(makeopts_jobs)" --dist=worksteal
}

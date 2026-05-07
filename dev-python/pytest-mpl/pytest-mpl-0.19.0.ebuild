# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Facilitate image comparison for Matplotlib figures"
HOMEPAGE="
	https://pypi.org/project/pytest-mpl/
	https://github.com/matplotlib/pytest-mpl
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# these tests are pinned to specific output image hashes
	# and none match nowadays
	tests/subtests/test_subtest.py
	tests/test_baseline_path.py::test_config
	tests/test_pytest_mpl.py::test_formats
	tests/test_results_always.py::test_config
	tests/test_use_full_test_name.py::test_config
)

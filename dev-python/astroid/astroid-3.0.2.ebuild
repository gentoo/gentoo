# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="
	https://github.com/pylint-dev/astroid/
	https://pypi.org/project/astroid/
"
SRC_URI="
	https://github.com/pylint-dev/astroid/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# Version specified in pyproject.toml
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
	' 3.10)
"
# dev-python/regex isn't available for pypy
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/attrs[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.17.0[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/regex[${PYTHON_USEDEP}]
		' 'python*')
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local EPYTEST_DESELECT=(
		# no clue why they're broken
		tests/test_modutils.py::GetModulePartTest::test_known_values_get_builtin_module_part
		tests/test_regrtest.py::NonRegressionTests::test_numpy_distutils
		# pydantic-2?
		tests/brain/test_dataclasses.py::test_pydantic_field
		# requires urllib3 with bundled six (skipped with urllib3>=2)
		tests/test_modutils.py::test_file_info_from_modpath__SixMetaPathImporter
		# requires pip, looks fragile
		tests/test_manager.py::IsolatedAstroidManagerTest::test_no_user_warning
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

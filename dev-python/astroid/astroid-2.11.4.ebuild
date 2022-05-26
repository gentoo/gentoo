# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="
	https://github.com/PyCQA/astroid/
	https://pypi.org/project/astroid/"
SRC_URI="
	https://github.com/PyCQA/astroid/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# Version specified in __pkginfo__.py.
RDEPEND="
	>=dev-python/lazy-object-proxy-1.4.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.10[${PYTHON_USEDEP}]
	<dev-python/wrapt-2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local EPYTEST_DESELECT=(
		# no clue why it's broken
		tests/unittest_modutils.py::GetModulePartTest::test_known_values_get_builtin_module_part
		tests/unittest_brain_dataclasses.py::test_pydantic_field
	)

	# Faker causes sys.path_importer_cache keys to be overwritten
	# with PosixPaths
	epytest -p no:faker
}

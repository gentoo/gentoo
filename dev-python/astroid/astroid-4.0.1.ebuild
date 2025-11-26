# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P=${P/_/}
DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="
	https://github.com/pylint-dev/astroid/
	https://pypi.org/project/astroid/
"
SRC_URI="
	https://github.com/pylint-dev/astroid/archive/v${PV/_/}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

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

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local EPYTEST_IGNORE=()
	local EPYTEST_DESELECT=(
		# hangs randomly
		tests/test_nodes.py::AsStringTest::test_recursion_error_trapped
		# no clue why they're broken
		tests/test_modutils.py::GetModulePartTest::test_known_values_get_builtin_module_part
		# TODO
		tests/test_builder.py::BuilderTest::test_data_build_error_filename
		# numpy-2 (https://github.com/pylint-dev/astroid/issues/2442)
		tests/brain/numpy/test_core_einsumfunc.py::test_numpy_function_calls_inferred_as_ndarray
		tests/brain/numpy/test_core_fromnumeric.py::BrainNumpyCoreFromNumericTest::test_numpy_function_calls_inferred_as_ndarray
		tests/brain/numpy/test_core_multiarray.py::BrainNumpyCoreMultiarrayTest::test_numpy_function_calls_inferred_as_ndarray
		tests/brain/numpy/test_core_numerictypes.py::NumpyBrainCoreNumericTypesTest::test_datetime_astype_return
		tests/brain/numpy/test_core_numerictypes.py::NumpyBrainCoreNumericTypesTest::test_generic_types_are_subscriptables
		tests/brain/numpy/test_core_umath.py::NumpyBrainCoreUmathTest::test_numpy_core_umath_functions_return_type
		tests/brain/numpy/test_core_umath.py::NumpyBrainCoreUmathTest::test_numpy_core_umath_functions_return_type_tuple
		# old pythons only
		tests/brain/test_dataclasses.py::test_pydantic_field
		tests/test_regrtest.py::NonRegressionTests::test_numpy_distutils
		# -Werror, sigh
		tests/test_nodes.py::test_deprecated_nodes_import_from_toplevel
	)

	if ! has_version "dev-python/mypy[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			tests/test_raw_building.py
		)
	fi

	epytest
}

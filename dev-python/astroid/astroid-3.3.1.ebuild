# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

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
		# hangs
		tests/test_nodes.py::AsStringTest::test_recursion_error_trapped
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
	)

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				tests/test_transforms.py::TestTransforms::test_transform_aborted_if_recursion_limited
			)
			;;
		python3.13)
			EPYTEST_DESELECT+=(
				# changes in py3.13.0b4
				# https://github.com/pylint-dev/astroid/issues/2478
				tests/test_nodes.py::AsStringTest::test_f_strings
				tests/test_nodes_lineno.py::TestLinenoColOffset::test_end_lineno_string
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Composable complex class support for attrs and dataclasses"
HOMEPAGE="
	https://pypi.org/project/cattrs/
	https://github.com/python-attrs/cattrs/
"
SRC_URI="
	https://github.com/python-attrs/cattrs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test-rust"

RDEPEND="
	>=dev-python/attrs-24.3.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.12.2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/cbor2-5.4.6[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.79.4[${PYTHON_USEDEP}]
		>=dev-python/immutables-0.20[${PYTHON_USEDEP}]
		>=dev-python/msgpack-1.0.5[${PYTHON_USEDEP}]
		>=dev-python/pymongo-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/tomlkit-0.11.8[${PYTHON_USEDEP}]
		>=dev-python/ujson-5.10.0[${PYTHON_USEDEP}]
		test-rust? (
			$(python_gen_cond_dep '
				>=dev-python/orjson-3.10.7[${PYTHON_USEDEP}]
			' 'python*')
		)
	)
"

# xdist can randomly break tests, depending on job count
# https://bugs.gentoo.org/941429
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local EPYTEST_IGNORE=(
		# requires msgspec
		tests/preconf/test_msgspec_cpython.py
	)
	local EPYTEST_DESELECT=(
		# these require msgspec
		tests/test_preconf.py::test_literal_dicts_msgspec
		tests/test_preconf.py::test_msgspec_efficient_enum
		tests/test_preconf.py::test_msgspec_json_converter
		tests/test_preconf.py::test_msgspec_json_unions
		tests/test_preconf.py::test_msgspec_json_unstruct_collection_overrides
		tests/test_preconf.py::test_msgspec_native_enums
	)

	if ! has_version "dev-python/orjson[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_preconf.py::test_orjson
			tests/test_preconf.py::test_orjson_converter
			tests/test_preconf.py::test_orjson_converter_unstruct_collection_overrides
		)
	fi

	# https://github.com/python-attrs/cattrs/issues/626
	# https://github.com/python-attrs/cattrs/pull/653
	if [[ ${EPYTHON} == python3.14* ]] ; then
		EPYTEST_DESELECT+=(
			'tests/strategies/test_include_subclasses.py::test_circular_reference[with-subclasses]'
			'tests/strategies/test_include_subclasses.py::test_overrides[wo-union-strategy-child1-only]'
			'tests/strategies/test_include_subclasses.py::test_overrides[wo-union-strategy-child2-only]'
			'tests/strategies/test_include_subclasses.py::test_overrides[wo-union-strategy-grandchild-only]'
			'tests/strategies/test_include_subclasses.py::test_overrides[wo-union-strategy-parent-only]'
			'tests/strategies/test_include_subclasses.py::test_parents_with_generics[False]'
			'tests/strategies/test_include_subclasses.py::test_parents_with_generics[True]'
			tests/strategies/test_include_subclasses.py::test_structure_as_union
			'tests/strategies/test_include_subclasses.py::test_structuring_unstructuring_unknown_subclass'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-child1-only]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-child2-only]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-grandchild-only]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-non-union-compose-child]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-non-union-compose-grandchild]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-non-union-compose-parent]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-non-union-container]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-parent-only]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-union-compose-child]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-union-compose-grandchild]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-union-compose-parent]'
			'tests/strategies/test_include_subclasses.py::test_structuring_with_inheritance[with-subclasses-union-container]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-child1-only]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-child2-only]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-grandchild-only]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-non-union-compose-child]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-non-union-compose-grandchild]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-non-union-compose-parent]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-non-union-container]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-parent-only]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-union-compose-child]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-union-compose-grandchild]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-union-compose-parent]'
			'tests/strategies/test_include_subclasses.py::test_unstructuring_with_inheritance[with-subclasses-union-container]'
			tests/test_gen_dict.py::test_type_names_with_quotes
			tests/test_generics.py::test_deep_copy
			'tests/test_generics.py::test_structure_nested_generics_with_cols[False-int-result0]'
			'tests/test_generics.py::test_structure_nested_generics_with_cols[False]'
			'tests/test_generics.py::test_structure_nested_generics_with_cols[True-int-result0]'
			'tests/test_generics.py::test_structure_nested_generics_with_cols[True]'
			'tests/test_self.py::test_nested_roundtrip[False]'
			'tests/test_self.py::test_nested_roundtrip[True]'
			'tests/test_self.py::test_self_roundtrip[False]'
			'tests/test_self.py::test_self_roundtrip[True]'
			'tests/test_self.py::test_self_roundtrip_dataclass[False]'
			'tests/test_self.py::test_self_roundtrip_dataclass[True]'
			'tests/test_self.py::test_self_roundtrip_namedtuple[False]'
			'tests/test_self.py::test_self_roundtrip_namedtuple[True]'
			'tests/test_self.py::test_self_roundtrip_typeddict[False]'
			'tests/test_self.py::test_self_roundtrip_typeddict[True]'
			'tests/test_self.py::test_subclass_roundtrip[False]'
			'tests/test_self.py::test_subclass_roundtrip[True]'
			'tests/test_self.py::test_subclass_roundtrip_dataclass[False]'
			'tests/test_self.py::test_subclass_roundtrip_dataclass[True]'
			tests/test_structure.py::test_structuring_unsupported
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= tests
}

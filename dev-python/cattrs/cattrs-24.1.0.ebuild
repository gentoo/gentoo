# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test-rust"

RDEPEND="
	>=dev-python/attrs-20.1.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.1.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/exceptiongroup[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/cbor2-5.4.6[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.54.5[${PYTHON_USEDEP}]
		>=dev-python/immutables-0.18[${PYTHON_USEDEP}]
		>=dev-python/msgpack-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/pymongo-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/tomlkit-0.11.4[${PYTHON_USEDEP}]
		>=dev-python/ujson-5.4.0[${PYTHON_USEDEP}]
		test-rust? (
			$(python_gen_cond_dep '
				>=dev-python/orjson-3.5.2[${PYTHON_USEDEP}]
			' 'python*')
		)
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/python-attrs/cattrs/pull/543
	"${FILESDIR}/${PN}-23.2.4_pre20240627-py313.patch"
)

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local EPYTEST_IGNORE=(
		# requires msgspec
		tests/preconf/test_msgspec_cpython.py
	)
	local EPYTEST_DESELECT=(
		# these require msgspec
		tests/test_preconf.py::test_msgspec_json_unstruct_collection_overrides
		tests/test_preconf.py::test_msgspec_json_unions
		tests/test_preconf.py::test_msgspec_json_converter

		# tests need updating for attrs-24*
		# https://github.com/python-attrs/cattrs/issues/575
		tests/test_baseconverter.py
		tests/test_converter.py
		tests/test_gen_dict.py::test_individual_overrides
		tests/test_gen_dict.py::test_nodefs_generated_unstructuring_cl
		tests/test_gen_dict.py::test_unmodified_generated_structuring
		tests/test_structure_attrs.py::test_structure_simple_from_dict_default
	)

	if ! has_version "dev-python/orjson[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_preconf.py::test_orjson
			tests/test_preconf.py::test_orjson_converter
			tests/test_preconf.py::test_orjson_converter_unstruct_collection_overrides
		)
	fi

	case ${EPYTHON} in
		python3.13)
			EPYTEST_DESELECT+=(
				tests/preconf/test_pyyaml.py::test_pyyaml
				tests/preconf/test_pyyaml.py::test_pyyaml_converter
				tests/test_converter.py::test_simple_roundtrip
				tests/test_gen_dict.py::test_unmodified_generated_structuring
				tests/test_generics.py::test_unstructure_deeply_nested_generics_list
				tests/test_unstructure_collections.py::test_collection_unstructure_override_mapping
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= tests
}

# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
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

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= tests
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_FULLY_TESTED=( python3_{12..14} )
PYTHON_COMPAT=( "${PYTHON_FULLY_TESTED[@]}" )
inherit distutils-r1 optfeature pypi

DESCRIPTION="Python library for serializing any arbitrary object graph into JSON"
HOMEPAGE="
	https://github.com/jsonpickle/jsonpickle/
	https://pypi.org/project/jsonpickle/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="test-full"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/feedparser[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/ujson[${PYTHON_USEDEP}]
		test-full? (
			$(python_gen_cond_dep '
				dev-python/gmpy2[${PYTHON_USEDEP}]
				dev-python/pandas[${PYTHON_USEDEP}]
			' "${PYTHON_FULLY_TESTED[@]}")
		)
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# unpackaged bson dependency
		tests/bson_test.py
	)
	local EPYTEST_DESELECT=(
		# new numpy
		tests/numpy_test.py::test_ndarray_roundtrip
		# new pandas
		tests/pandas_test.py::test_dataframe_roundtrip
		tests/pandas_test.py::test_multindex_dataframe_roundtrip
		tests/pandas_test.py::test_pre_v3_4_df_decoding
	)

	if ! has_version "dev-python/gmpy2[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=( jsonpickle/ext/gmpy.py )
	fi
	if ! has_version "dev-python/pandas[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=( jsonpickle/ext/pandas.py )
	fi

	# ignore DeprecationWarnings from numpy, since upstream is matching
	# on exact warning count
	epytest -Wignore::DeprecationWarning tests
}

pkg_postinst() {
	# Unpackaged optional backends: yajl, demjson
	optfeature "encoding numpy-based data" dev-python/numpy
	optfeature "encoding pandas objects" dev-python/pandas
	optfeature "fast JSON backend" dev-python/simplejson
}

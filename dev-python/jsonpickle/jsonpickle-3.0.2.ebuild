# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 optfeature

DESCRIPTION="Python library for serializing any arbitrary object graph into JSON"
HOMEPAGE="
	https://github.com/jsonpickle/jsonpickle/
	https://pypi.org/project/jsonpickle/
"
SRC_URI="
	https://github.com/jsonpickle/jsonpickle/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/feedparser[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/ujson[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/gmpy[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
		' python3_{10..11})
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e 's:--cov::' pytest.ini || die
	distutils-r1_python_prepare_all
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	local EPYTEST_DESELECT=(
		# problem when pandas are built with Cython 3.0.0
		# https://github.com/jsonpickle/jsonpickle/issues/460
		tests/pandas_test.py::test_timedelta_index_roundtrip
	)
	local EPYTEST_IGNORE=(
		# unpackaged bson dependency
		tests/bson_test.py
	)

	if ! has_version "dev-python/gmpy[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=( jsonpickle/ext/gmpy.py )
	fi
	if ! has_version "dev-python/pandas[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=( jsonpickle/ext/pandas.py )
	fi

	epytest
}

pkg_postinst() {
	# Unpackaged optional backends: yajl, demjson
	optfeature "encoding numpy-based data" dev-python/numpy
	optfeature "encoding pandas objects" dev-python/pandas
	optfeature "fast JSON backend" dev-python/simplejson
}

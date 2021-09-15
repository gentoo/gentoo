# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature

DESCRIPTION="Python library for serializing any arbitrary object graph into JSON"
HOMEPAGE="https://github.com/jsonpickle/jsonpickle/ https://pypi.org/project/jsonpickle/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

# toml via setuptools_scm[toml]
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/ujson[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/feedparser[${PYTHON_USEDEP}]
		' python3_{8,9})
	)"

distutils_enable_sphinx docs \
	dev-python/jaraco-packaging \
	dev-python/rst-linker
distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e 's:--flake8 --black --cov::' pytest.ini || die
	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_IGNORE=(
		# unpackaged bson dependency
		tests/bson_test.py
		# broken when gmpy is installed
		# https://github.com/jsonpickle/jsonpickle/issues/328
		# https://github.com/jsonpickle/jsonpickle/issues/316
		tests/ecdsa_test.py
	)
	# There is a problem with packaging feedparser with python 3.10, so skip
	[[ ${EPYTHON} == python3_10 ]] && EPYTEST_IGNORE+=(
		tests/feedparser_test.py
	)
	epytest
}

pkg_postinst() {
	# Unpackaged optional backends: yajl, demjson
	optfeature "encoding numpy-based data" dev-python/numpy
	optfeature "encoding pandas objects" dev-python/pandas
	optfeature "fast JSON backend" dev-python/simplejson
}

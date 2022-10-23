# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 optfeature

DESCRIPTION="Python library for serializing any arbitrary object graph into JSON"
HOMEPAGE="
	https://github.com/jsonpickle/jsonpickle/
	https://pypi.org/project/jsonpickle/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/feedparser[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/ujson[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# https://github.com/jsonpickle/jsonpickle/pull/396
	"${FILESDIR}/${P}-python3.11.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e 's:--flake8 --cov::' pytest.ini || die
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
	epytest
}

pkg_postinst() {
	# Unpackaged optional backends: yajl, demjson
	optfeature "encoding numpy-based data" dev-python/numpy
	optfeature "encoding pandas objects" dev-python/pandas
	optfeature "fast JSON backend" dev-python/simplejson
}

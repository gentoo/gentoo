# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="Python library for serializing any arbitrary object graph into JSON"
HOMEPAGE="https://github.com/jsonpickle/jsonpickle/ https://pypi.org/project/jsonpickle/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

# There are optional json backends serializer/deserializers in addition to those selected here
# jsonlib, yajl.
RDEPEND="
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/importlib_metadata[${PYTHON_USEDEP}]
	' python3_7)
"
# toml via setuptools_scm[toml]
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]"

distutils_enable_sphinx "docs/source"
distutils_enable_tests pytest

python_prepare_all() {
	# too many dependencies
	rm tests/pandas_test.py || die
	# broken with gmpy
	rm tests/ecdsa_test.py || die

	sed -i -e 's:--flake8 --black --cov::' pytest.ini || die

	distutils-r1_python_prepare_all
}

python_test() {
	pytest -vv tests || die "Tests failed with ${EPYTHON}"
}

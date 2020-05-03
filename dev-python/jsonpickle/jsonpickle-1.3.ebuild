# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python library for serializing any arbitrary object graph into JSON"
HOMEPAGE="https://github.com/jsonpickle/jsonpickle/ https://pypi.org/project/jsonpickle/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

# There are optional json backends serializer/deserializers in addition to those selected here
# jsonlib, yajl.
RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/feedparser[${PYTHON_USEDEP}]
		dev-python/ujson[${PYTHON_USEDEP}]
		"
DEPEND="test? ( ${RDEPEND} )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Prevent un-needed d'loading during doc build
	sed -e "s/, 'sphinx.ext.intersphinx'//" -i docs/source/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && { python_setup python2_7 && sphinx-build -b html -c docs/source/ docs/source/ docs/source/html || die; }
}

python_test() {
	# An apparent regression in tests
	# https://github.com/jsonpickle/jsonpickle/issues/124
	einfo "testsuite has optional tests for package demjson"
	${PYTHON} tests/runtests.py || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/source/html/. )
	distutils-r1_python_install_all
}

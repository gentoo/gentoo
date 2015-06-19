# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jsonpickle/jsonpickle-0.8.0.ebuild,v 1.3 2015/03/08 23:51:48 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python library for serializing any arbitrary object graph into JSON"
HOMEPAGE="http://jsonpickle.github.com/ http://pypi.python.org/pypi/jsonpickle"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

# There are optional json backends in addition to those selected here
# jsonlib, demjson, yajl, jsonlib
RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/feedparser[${PYTHON_USEDEP}]
		dev-python/ujson[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND} )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/sphinxtogithub[${PYTHON_USEDEP}]' python2_7) )"

PATCHES=( "${FILESDIR}"/${PN}-0.6.1-drop-brocken-backend.patch )

python_prepare_all() {
	# Prevent un-needed d'loading during doc build
	sed -e "s/, 'sphinx.ext.intersphinx'//" -i docs/source/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && sphinx-build -b html -c docs/source/ docs/source/ docs/source/html
}

python_test() {
	einfo "testsuite has optional tests for package demjson"
	${PYTHON} tests/runtests.py || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/source/html/. )
	distutils-r1_python_install_all
}

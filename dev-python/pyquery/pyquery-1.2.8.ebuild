# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1 eutils

DESCRIPTION="A jQuery-like library for python"
HOMEPAGE="https://github.com/gawel/pyquery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	>=dev-python/lxml-2.1[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2[${PYTHON_USEDEP}]
	dev-python/webtest[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip
	test? ( ${RDEPEND}
		dev-python/beautifulsoup:python-2[$(python_gen_usedep 'python2*')]
		dev-python/beautifulsoup:python-3[$(python_gen_usedep 'python3*')]
		dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# rm known failing tests and tests dependent on restkit
	# https://github.com/gawel/pyquery/pull/63/files
	sed -e "s/test_proxy/_&/" \
		-e "s/test_replaceWith/_&/" \
		-i tests/test_pyquery.py || die
	rm docs/ajax.rst || die
	distutils-r1_python_prepare_all
}

python_test() {
	# The suite, it appears, requires this hard setting of PYTHONPATH!
	PYTHONPATH=. nosetests || die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "Support for BeautifulSoup3 as a parser backend" dev-python/beautifulsoup
}

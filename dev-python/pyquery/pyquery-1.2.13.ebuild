# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1 eutils

DESCRIPTION="A jQuery-like library for python"
HOMEPAGE="https://github.com/gawel/pyquery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ppc64 s390 ~sh sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/lxml-2.1[${PYTHON_USEDEP}]
	>dev-python/cssselect-0.7.9[${PYTHON_USEDEP}]
	>=dev-python/webob-1.1.9[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/beautifulsoup[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/restkit[${PYTHON_USEDEP}]' 'python2_7') )"

python_prepare_all() {
	# Disable tests needing a network connection
	sed -i -e "s/HAS_REQUEST = True/HAS_REQUEST = False/" tests/test_pyquery.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# The suite, it appears, requires this hard setting of PYTHONPATH!
	PYTHONPATH=. nosetests || die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "Support for BeautifulSoup3 as a parser backend" dev-python/beautifulsoup
}

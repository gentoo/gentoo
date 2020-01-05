# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

MY_PN="wsgi_intercept"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="WSGI application in place of a real URI for testing"
HOMEPAGE="https://github.com/cdent/python3-wsgi-intercept"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"
RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	test? (
		dev-python/httplib2[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.4[${PYTHON_USEDEP}]
		>=dev-python/requests-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/urllib3-1.11.0[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mechanize[${PYTHON_USEDEP}]' python2_7 pypy)
	)"
S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# .pyc files cause failure of tests
	rm -rf test/__pycache__/ || die

	# Req'd to avoid file collisions
	sed -e s":find_packages():find_packages(exclude=['test']):" \
		-i setup.py || die

	# Disable tests connecting to the network; Bug #550710
	sed -e 's:test_http_not_intercepted:_&:' \
		-e 's:test_https_not_intercepted:_&:' \
		-i test/{test_urllib.py,test_http_client.py,test_requests.py} || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html//. )
	distutils-r1_python_install_all
}

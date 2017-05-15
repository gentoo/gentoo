# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="https://github.com/shazow/urllib3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-cygwin ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="test"

RDEPEND="
	>=dev-python/PySocks-1.5.6[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.3.4[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0.0[${PYTHON_USEDEP}]
	virtual/python-ipaddress[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=www-servers/tornado-4.2.1[$(python_gen_usedep 'python*')]
		>=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/nose-exclude-0.4.1[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"

# Testsuite written requiring mock to be installed under all Cpythons

python_compile_all() {
	use doc && emake -C docs SPHINXOPTS= html
}

python_test() {
	# FIXME: get tornado ported
	if [[ ${EPYTHON} == python* ]]; then
		nosetests -v test || die "Testing failed with ${EPYTHON}"
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}

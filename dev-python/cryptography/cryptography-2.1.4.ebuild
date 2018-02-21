# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic

DESCRIPTION="Library providing cryptographic recipes and primitives"
HOMEPAGE="https://github.com/pyca/cryptography/ https://pypi.python.org/pypi/cryptography/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x64-solaris"
IUSE="libressl test"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= ( || ( dev-libs/openssl:0[-bindist(-)]
										=dev-libs/openssl-1.0.2l-r1:0
										>=dev-libs/openssl-1.1.0g-r1:0 ) ) )
	libressl? ( dev-libs/libressl )
	$(python_gen_cond_dep '>=dev-python/cffi-1.7:=[${PYTHON_USEDEP}]' 'python*')
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7 pypy{,3})
	>=dev-python/idna-2.1[${PYTHON_USEDEP}]
	>=dev-python/asn1crypto-0.21.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
	virtual/python-ipaddress[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-1.0[${PYTHON_USEDEP}]
	test? (
		~dev-python/cryptography-vectors-${PV}[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/iso8601[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.9.0[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS.rst CONTRIBUTING.rst README.rst )

python_configure_all() {
	append-cflags $(test-flags-CC -pthread)
}

python_test() {
	py.test -v -v -x || die "Tests fail with ${EPYTHON}"
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy{,3} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic

DESCRIPTION="Library providing cryptographic recipes and primitives"
HOMEPAGE="https://github.com/pyca/cryptography/ https://pypi.org/project/cryptography/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="libressl test"
RESTRICT="!test? ( test )"

# the openssl 1.0.2l-r1 needs to be updated again :(
# It'd theb be able to go into the || section again
#=dev-libs/openssl-1.0.2l-r1:0
# the following is the original section, disallowing bindist entirely
#!libressl? ( >=dev-libs/openssl-1.0.2:0=[-bindist(-)] )
RDEPEND="
	!libressl? (
		dev-libs/openssl:0= (
			|| (
				dev-libs/openssl:0[-bindist(-)]
				>=dev-libs/openssl-1.0.2o-r6:0
			)
		)
	)
	libressl? ( dev-libs/libressl:0= )
	$(python_gen_cond_dep '>=dev-python/cffi-1.7:=[${PYTHON_USEDEP}]' 'python*')
	>=dev-python/idna-2.1[${PYTHON_USEDEP}]
	>=dev-python/asn1crypto-0.21.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
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

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.4-libressl-2.7-x509.patch
	"${FILESDIR}"/${PN}-2.1.4-libressl-2.7-x509_vfy.patch
	"${FILESDIR}"/CVE-2018-10903.patch
)

python_configure_all() {
	append-cflags $(test-flags-CC -pthread)
}

python_test() {
	py.test -v -v -x || die "Tests fail with ${EPYTHON}"
}

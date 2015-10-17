# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# only works with >=pypy-2.6
PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1

DESCRIPTION="Library providing cryptographic recipes and primitives"
HOMEPAGE="https://github.com/pyca/cryptography/ https://pypi.python.org/pypi/cryptography/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh x86 ~amd64-linux ~x86-linux"
IUSE="libressl test"

RDEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	$(python_gen_cond_dep '>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]' 'python*')
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7 python3_3 pypy)
	>=dev-python/idna-2.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/ipaddress[${PYTHON_USEDEP}]' python2_7 pypy)
	>=dev-python/pyasn1-0.1.8[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=virtual/pypy-2.6.0' pypy )
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		~dev-python/cryptography-vectors-${PV}[${PYTHON_USEDEP}]
		dev-python/iso8601[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.4.2[${PYTHON_USEDEP}]
		<dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS.rst CONTRIBUTING.rst README.rst )

python_test() {
	py.test -v -v -x || die "Tests fail with ${EPYTHON}"
}

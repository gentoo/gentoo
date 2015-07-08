# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cryptography/cryptography-0.9.2.ebuild,v 1.1 2015/07/08 09:15:41 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy )

inherit distutils-r1

DESCRIPTION="Library providing cryptographic recipes and primitives"
HOMEPAGE="https://github.com/pyca/cryptography/ https://pypi.python.org/pypi/cryptography/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-libs/openssl:0
	$(python_gen_cond_dep '>=dev-python/cffi-0.8:=[${PYTHON_USEDEP}]' 'python*')
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7 python3_3 pypy)
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/ipaddress[$(python_gen_usedep python2_7 pyp)]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		~dev-python/cryptography-vectors-${PV}[${PYTHON_USEDEP}]
		dev-python/iso8601[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.4.2[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS.rst CONTRIBUTING.rst README.rst )

python_test() {
	py.test -v || die "Tests fail with ${EPYTHON}"
}

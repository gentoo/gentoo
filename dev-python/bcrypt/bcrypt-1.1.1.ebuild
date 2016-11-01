# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 pypy )

inherit distutils-r1

DESCRIPTION="Modern password hashing for software and servers"
HOMEPAGE="https://github.com/pyca/bcrypt/ https://pypi.python.org/pypi/bcrypt/"
SRC_URI="
	https://github.com/pyca/bcrypt/archive/v${PV}.tar.gz -> ${P}.tar.gz
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ia64 ppc ppc64 x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/cffi:=[${PYTHON_USEDEP}]' 'python*')
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		)"
RDEPEND="
	$(python_gen_cond_dep 'dev-python/cffi:=[${PYTHON_USEDEP}]' 'python*')
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
	!dev-python/py-bcrypt"

DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	esetup.py test
}

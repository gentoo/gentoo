# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Modern password hashing for software and servers"
HOMEPAGE="https://github.com/pyca/bcrypt/ https://pypi.python.org/pypi/bcrypt/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ia64 ppc ppc64 ~sparc x86"
IUSE="test"

COMMON_DEPEND="
	$(python_gen_cond_dep '>=dev-python/cffi-1.1:=[${PYTHON_USEDEP}]' 'python*')
	$(python_gen_cond_dep '>=virtual/pypy-2.6.0' pypy )
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	!dev-python/py-bcrypt"

python_test() {
	esetup.py test
}

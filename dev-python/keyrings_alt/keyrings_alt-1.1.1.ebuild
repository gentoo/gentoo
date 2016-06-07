# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} pypy )

inherit distutils-r1

MY_PN="${PN/_/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Alternate keyring implementations"
HOMEPAGE="https://github.com/jaraco/keyrings.alt http://pypi.python.org/pypi/keyrings.alt"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/fs[${PYTHON_USEDEP}]
		dev-python/gdata[$(python_gen_usedep 'python2*')]
		dev-python/keyczar[$(python_gen_usedep 'python2*')]
		dev-python/pycrypto[$(python_gen_usedep 'python*')]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}"/${MY_P}

# Multiple failures
RESTRICT=test

python_prepare_all() {
	sed \
		-e "s:find_packages():find_packages(exclude=['tests']):g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v -v || die
}

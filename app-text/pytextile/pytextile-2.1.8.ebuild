# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

MY_PN="textile"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Python implementation of Textile, Dean Allen's Human Text Generator for creating (X)HTML"
HOMEPAGE="https://github.com/ikirudennis/python-textile"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RDEPEND=""

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-sanitizer.patch )

python_prepare_all() {
	# This resolves a nasty race condition noted and observed by Arfrever
	sed -e 's:with-id = 1::' -i setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests textile/tests/ || die "Tests failed under ${EPYTHON}"
}

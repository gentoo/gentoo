# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Whirlpool"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Bindings for whirlpool hash reference implementation"
HOMEPAGE="https://pypi.python.org/pypi/Whirlpool https://github.com/radiosilence/python-whirlpool"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	sed \
		-e "/data_files/s:whirlpool:share/whirlpool:g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	${PYTHON} "${FILESDIR}"/tests.py || die
}

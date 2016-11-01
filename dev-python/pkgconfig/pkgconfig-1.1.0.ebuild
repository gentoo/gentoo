# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Interface Python with pkg-config"
HOMEPAGE="https://pypi.python.org/pypi/pkgconfig/ https://github.com/matze/pkgconfig"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/nose-1[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	sed -e '/nose/d' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die
}

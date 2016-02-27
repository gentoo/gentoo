# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy pypy3 )

inherit distutils-r1

MY_PN=""
DESCRIPTION="Python implementation of the Engine.IO realtime server."
HOMEPAGE="https://${PN}.readthedocs.org/ https://github.com/miguelgrinberg/${PN}/ https://pypi.python.org/pypi/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# pypi tarball does not contain tests
RESTRICT="test"

python_test() {
	esetup.py test || die
}

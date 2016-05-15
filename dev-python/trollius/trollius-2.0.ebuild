# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{3,4}} pypy )

inherit distutils-r1

DESCRIPTION="A port of the Tulip project (asyncio module, PEP3156)"
HOMEPAGE="https://github.com/haypo/trollius https://pypi.python.org/pypi/trollius/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="virtual/python-futures[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" runtests.py || die "Testing failed under ${EPYTHON}"
}

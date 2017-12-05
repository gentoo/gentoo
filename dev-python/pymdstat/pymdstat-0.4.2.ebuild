# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python library to parse Linux /proc/mdstat"
HOMEPAGE="https://github.com/nicolargo/pymdstat http://pypi.python.org/pypi/pymdstat"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# Not included
RESTRICT=test

python_test() {
	${PYTHON} unitest.py || die
}

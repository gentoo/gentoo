# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="py.test plugin to abort hanging tests"
HOMEPAGE="https://pypi.python.org/pypi/pytest-timeout"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/pytest"
DEPEND="${RDEPEND}"

python_test() {
	${EPYTHON} test_pytest_timeout.py || die
}

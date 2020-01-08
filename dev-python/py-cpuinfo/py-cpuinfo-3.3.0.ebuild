# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 pypy3 )

inherit distutils-r1

DESCRIPTION="Get CPU info with pure Python 2 & 3"
HOMEPAGE="https://github.com/workhorsy/py-cpuinfo https://pypi.org/project/py-cpuinfo/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( ChangeLog )

python_test() {
	"${PYTHON}" test_suite.py -v || die
}

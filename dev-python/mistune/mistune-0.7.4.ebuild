# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="The fastest markdown parser in pure Python"
HOMEPAGE="https://pypi.python.org/pypi/mistune https://github.com/lepture/mistune"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/cython[$(python_gen_usedep 'python*')]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_test() {
	nosetests || die
}

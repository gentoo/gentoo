# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3)

inherit distutils-r1

DESCRIPTION="Collection of small Python functions & classes"
HOMEPAGE="https://pypi.org/project/python-utils/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

python_test() {
	"${PYTHON}" ./test_flakes.py || die "Tests failed under ${EPYTHON}"
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="A pure python implementation of a sliding window memory map manager"
HOMEPAGE="
	https://pypi.org/project/smmap2/
	https://github.com/gitpython-developers/smmap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 arm64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"
RDEPEND="
	!dev-python/smmap[${PYTHON_USEDEP}]"

python_test() {
	nosetests -v || die "tests failed under ${EPYTHON}"
}

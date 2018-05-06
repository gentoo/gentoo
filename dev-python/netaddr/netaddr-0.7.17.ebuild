# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Network address representation and manipulation library"
HOMEPAGE="https://github.com/drkjam/netaddr https://pypi.org/project/netaddr https://netaddr.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cli test"

RDEPEND="cli? ( >=dev-python/ipython-0.13.1-r1[${PYTHON_USEDEP}] )"
DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		${RDEPEND}
	)"

python_test() {
	esetup.py test
}

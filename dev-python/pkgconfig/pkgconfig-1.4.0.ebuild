# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="Interface Python with pkg-config"
HOMEPAGE="https://pypi.org/project/pkgconfig/ https://github.com/matze/pkgconfig"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/pkgconfig"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -e '/nose/d' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die
}

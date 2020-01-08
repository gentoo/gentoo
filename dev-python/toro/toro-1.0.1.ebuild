# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Synchronization primitives for Tornado coroutines"
HOMEPAGE="https://github.com/ajdavis/toro/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/python-futures[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )
"
PATCHES=(
	"${FILESDIR}"/${P}-no-test-install.patch
)
python_test() {
	esetup.py test
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}

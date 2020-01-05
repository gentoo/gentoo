# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A python implementation for Noise Protocol Framework"
HOMEPAGE="https://github.com/tgalal/dissononce"
SRC_URI="https://github.com/tgalal/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples test"

# Currently no tests are available,
# they will be added in future by upstream.
RESTRICT="test"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/transitions[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-fix-test-requirements.patch" )

python_test() {
	esetup.py test
}

src_install() {
	distutils-r1_src_install

	use examples && dodoc examples/patterns/*.py
}

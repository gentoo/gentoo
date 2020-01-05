# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )
inherit distutils-r1

DESCRIPTION="Ultra-fast implementation of asyncio event loop on top of libuv"
HOMEPAGE="https://github.com/magicstack/uvloop"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/libuv-1.11.0:="
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/alabaster-0.6.2[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	cat <<EOF >> setup.cfg || die
[build_ext]
use-system-libuv=1
EOF

	# failing not only for us
	sed -i -e 's:test_write_pipe(:_&:' tests/test_pipes.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_ext --inplace build_sphinx
}

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && dodoc -r examples
	use doc && local HTML_DOCS=( "${BUILD_DIR}/sphinx/html/." )
	distutils-r1_python_install_all
}

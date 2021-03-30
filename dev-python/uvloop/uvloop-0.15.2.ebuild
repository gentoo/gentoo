# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Ultra-fast implementation of asyncio event loop on top of libuv"
HOMEPAGE="https://github.com/magicstack/uvloop"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 x86"
LICENSE="MIT"
SLOT="0"
IUSE="doc examples"

RDEPEND=">=dev-libs/libuv-1.11.0:="
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		>=dev-python/alabaster-0.6.2[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests setup.py

python_prepare_all() {
	cat <<EOF >> setup.cfg || die
[build_ext]
use-system-libuv=1
EOF

	# flake8 only
	rm tests/test_sourcecode.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_ext --inplace build_sphinx
}

python_install_all() {
	use examples && dodoc -r examples
	use doc && local HTML_DOCS=( "${BUILD_DIR}/sphinx/html/." )
	distutils-r1_python_install_all
}

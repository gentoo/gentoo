# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Ultra-fast implementation of asyncio event loop on top of libuv"
HOMEPAGE="https://github.com/magicstack/uvloop"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ppc ~ppc64 -riscv sparc"
LICENSE="MIT"
SLOT="0"
IUSE="doc examples"

RDEPEND=">=dev-libs/libuv-1.11.0:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
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

PATCHES=(
	"${FILESDIR}"/${P}-uint64-thread-id.patch
)

python_prepare_all() {
	cat <<-EOF >> setup.cfg || die
		[build_ext]
		use_system_libuv=1
	EOF

	# flake8 only
	rm tests/test_sourcecode.py || die
	# TODO: broken by cythonize
	rm tests/test_cython.py || die
	# force cythonization
	rm uvloop/loop.c || die

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

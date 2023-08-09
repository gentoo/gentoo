# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
# TODO: Find out exactly where this error comes from
# error: '<' not supported between instances of 'str' and 'int'
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Lightweight and super-fast messaging library built on top of the ZeroMQ library"
HOMEPAGE="
	https://zeromq.org/languages/python/
	https://pypi.org/project/pyzmq/
	https://github.com/zeromq/pyzmq/
"
SRC_URI="
	https://github.com/zeromq/pyzmq/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="drafts"

# There are additional test failures if zeromq has the draft api enabled, but pyzmq has it disabled.
DEPEND="
	>=net-libs/zeromq-4.2.2-r2:=[drafts=]
"
# It uses cffi backend for pypy, cython backend for cpython
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/py[${PYTHON_USEDEP}]
		dev-python/cffi:=[${PYTHON_USEDEP}]
	' pypy3)
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
	' 'python*')
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		>=dev-python/tornado-5.0.2[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-23.2.0-libdir.patch
	# fix build_ext -j... invocation used by PEP517 build
	# https://github.com/zeromq/pyzmq/pull/1872
	"${FILESDIR}"/${P}-build_ext.patch
)

EPYTEST_DESELECT=(
	# TODO
	zmq/tests/test_auth.py
	zmq/tests/test_cython.py
	zmq/tests/test_zmqstream.py
)

EPYTEST_IGNORE=(
	# Avoid dependency on mypy
	zmq/tests/test_mypy.py
)

distutils_enable_tests pytest
# TODO: Package enum_tools
# distutils_enable_sphinx docs/source \
# 	dev-python/numpydoc \
# 	dev-python/sphinx-rtd-theme \
# 	dev-python/myst-parser

python_prepare_all() {
	export ZMQ_DRAFT_API=$(usex drafts '1' '0')
	export ZMQ_PREFIX="${EPREFIX}/usr"
	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest -p asyncio -p rerunfailures
}

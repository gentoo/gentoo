# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
# TODO: Find out exactly where this error comes from
# error: '<' not supported between instances of 'str' and 'int'
#DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="threads(+)"

inherit flag-o-matic distutils-r1 toolchain-funcs

DESCRIPTION="Lightweight and super-fast messaging library built on top of the ZeroMQ library"
HOMEPAGE="
	https://zeromq.org/languages/python/
	https://pypi.org/project/pyzmq/
	https://github.com/zeromq/pyzmq/"
SRC_URI="
	https://github.com/zeromq/pyzmq/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+draft"

DEPEND="
	>=net-libs/zeromq-4.2.2-r2:=[drafts]
"
# it uses cffi backend for pypy, cython backend for cpython
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
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		>=dev-python/tornado-5.0.2[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-23.2.0-libdir.patch
)

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	"dev-python/numpydoc"

python_configure_all() {
	tc-export CC
	append-cppflags -DZMQ_BUILD_DRAFT_API=$(usex draft '1' '0')
}

python_compile() {
	esetup.py cython --force
	ZMQ_PREFIX="${EPREFIX}/usr" distutils-r1_python_compile
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		zmq/tests/test_constants.py::TestConstants::test_draft
		zmq/tests/test_cython.py::test_cython

		# hangs often
		zmq/tests/test_log.py::TestPubLog::test_blank_root_topic
	)
	local EPYTEST_IGNORE=(
		zmq/tests/test_mypy.py
	)

	cd "${BUILD_DIR}/lib" || die
	epytest -p no:flaky
}

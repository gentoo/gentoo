# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
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
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
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
		>=www-servers/tornado-5.0.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	"dev-python/numpydoc"

python_configure_all() {
	tc-export CC
	append-cppflags -DZMQ_BUILD_DRAFT_API=$(usex draft '1' '0')
}

python_compile() {
	esetup.py cython --force
	distutils-r1_python_compile
}

python_test() {
	local deselect=(
		# TODO
		zmq/tests/test_constants.py::TestConstants::test_draft
		zmq/tests/test_cython.py::test_cython

		# hangs often
		zmq/tests/test_log.py::TestPubLog::test_blank_root_topic
	)

	cd "${BUILD_DIR}"/lib || die
	epytest -p no:flaky ${deselect[@]/#/--deselect } \
		--ignore zmq/tests/test_mypy.py
	rm -rf .hypothesis .pytest_cache || die
}

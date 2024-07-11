# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( pypy3 python3_{10..13} )
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
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="drafts"

# There are additional test failures if zeromq has the draft api enabled, but pyzmq has it disabled.
DEPEND="
	>=net-libs/zeromq-4.2.2-r2:=[drafts=]
"
# It uses cffi backend for pypy, cython backend for cpython
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]
	' 'python*')
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		>=dev-python/tornado-5.0.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# TODO: Package enum_tools
# distutils_enable_sphinx docs/source \
# 	dev-python/numpydoc \
# 	dev-python/sphinx-rtd-theme \
# 	dev-python/myst-parser

PATCHES=(
	# https://github.com/zeromq/pyzmq/pull/1990
	"${FILESDIR}/${P}-gcc14.patch"
)

src_configure() {
	DISTUTILS_ARGS=(
		-DZMQ_DRAFT_API="$(usex drafts)"
	)
}

src_test() {
	# need to move them around to make EPYTEST_IGNORE work cleanly
	# with tests-in-package and extension modules
	mv zmq/tests . || die
	rm -r zmq || die
	distutils-r1_src_test
}

python_test() {
	local EPYTEST_IGNORE=(
		# Avoid dependency on mypy
		tests/test_mypy.py
	)

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# not implemented in cffi variant?
				tests/test_draft.py::TestDraftSockets
			)
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# avoid large to reduce memory consumption
	epytest -p asyncio -p rerunfailures tests -m "not large"
}

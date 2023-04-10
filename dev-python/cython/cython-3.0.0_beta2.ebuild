# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 toolchain-funcs

MY_P=${P/_beta/b}
DESCRIPTION="A Python to C compiler"
HOMEPAGE="
	https://cython.org/
	https://github.com/cython/cython/
	https://pypi.org/project/Cython/
"
SRC_URI="
	https://github.com/cython/cython/archive/${PV/_beta/b}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		' python3_{8..10})
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.29.22-spawn-multiprocessing.patch"
	"${FILESDIR}/${PN}-0.29.23-test_exceptions-py310.patch"
	"${FILESDIR}/${PN}-0.29.23-pythran-parallel-install.patch"
)

distutils_enable_sphinx docs \
	dev-python/jinja \
	dev-python/sphinx-issues \
	dev-python/sphinx-tabs

python_compile() {
	# Python gets confused when it is in sys.path before build.
	local -x PYTHONPATH=

	distutils-r1_python_compile
}

python_test() {
	if has "${EPYTHON}" pypy3 python3.11; then
		einfo "Skipping tests on ${EPYTHON} (xfail)"
		return
	fi

	tc-export CC
	# https://github.com/cython/cython/issues/1911
	local -x CFLAGS="${CFLAGS} -fno-strict-overflow"
	"${PYTHON}" runtests.py -vv --work-dir "${BUILD_DIR}"/tests ||
		die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES.rst README.rst ToDo.txt USAGE.txt )
	distutils-r1_python_install_all
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="C parser and AST generator written in Python"
HOMEPAGE="https://github.com/eliben/pycparser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="dev-python/ply:=[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# remove the original files to guarantee their regen
	rm pycparser/{c_ast,lextab,yacctab}.py || die

	# kill sys.path manipulations to force the tests to use built files
	sed -i -e '/sys\.path/d' tests/*.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile

	# note: tables built by py3.5+ are incompatible with older versions
	# because of 100 group limit of 're' module -- just generate them
	# separately optimized for each target instead
	pushd "${BUILD_DIR}"/lib/pycparser > /dev/null || die
	"${PYTHON}" _build_tables.py || die
	popd > /dev/null || die
}

python_test() {
	# change workdir to avoid '.' import
	cd tests || die
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# setup.py generates {c_ast,lextab,yacctab}.py with bytecode disabled.
	python_optimize
}

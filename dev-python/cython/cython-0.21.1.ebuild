# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cython/cython-0.21.1.ebuild,v 1.7 2015/02/26 18:48:12 maekke Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 flag-o-matic toolchain-funcs

MY_PN="Cython"
MY_P="${MY_PN}-${PV/_/}"

DESCRIPTION="A Python to C compiler"
HOMEPAGE="http://www.cython.org/ http://pypi.python.org/pypi/Cython"
SRC_URI="http://www.cython.org/release/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( $(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' 'python*') )"

S="${WORKDIR}/${MY_PN}-${PV%_*}"

python_compile() {
	if [[ ${EPYTHON} == python2* ]]; then
		local CFLAGS="${CFLAGS}"
		local CXXFLAGS="${CXXFLAGS}"
		append-flags -fno-strict-aliasing
	fi

	# Python gets confused when it is in sys.path before build.
	local PYTHONPATH=
	export PYTHONPATH

	distutils-r1_python_compile
}

python_compile_all() {
	use doc && unset XDG_CONFIG_HOME && emake -C docs html
}

python_test() {
	tc-export CC
	"${PYTHON}" runtests.py -vv --work-dir "${BUILD_DIR}"/tests \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES.rst README.txt ToDo.txt USAGE.txt )
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}

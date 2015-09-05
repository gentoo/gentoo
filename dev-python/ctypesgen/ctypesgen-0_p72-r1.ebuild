# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python wrapper generator for ctypes"
HOMEPAGE="https://github.com/davidjamesca/ctypesgen"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

python_prepare_all() {
	# r73 upstream
	sed -i -e 's:libc:libm.so.6:' test/math_functions.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	cp -r -l test "${BUILD_DIR}"/ || die

	cd "${BUILD_DIR}"/test || die
	local f
	for f in {math_functions,simple_macros,structures}.py; do
		"${PYTHON}" "${f}" || die "Test ${f} fails with ${EPYTHON}"
	done
}

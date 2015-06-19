# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dnspython/dnspython-1.12.0-r1.ebuild,v 1.2 2015/03/06 11:44:03 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 multilib

PN3="${PN}3"
P3="${PN3}-${PV}"

DESCRIPTION="DNS toolkit for Python"
HOMEPAGE="http://www.dnspython.org/ http://pypi.python.org/pypi/dnspython"
SRC_URI="http://www.dnspython.org/kits/${PV}/${P}.tar.gz
	http://www.dnspython.org/kits3/${PV}/${P3}.zip"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="examples test"

DEPEND="dev-python/pycrypto[${PYTHON_USEDEP}]
	app-arch/unzip"
RDEPEND="${DEPEND}"

S2="${S}"
S3="${WORKDIR}/${P3}"

# For testsuite
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare() {
	if python_is_python3; then
		cp -r "${WORKDIR}/${P3}" "${BUILD_DIR}" || die
	else
		distutils-r1_python_prepare
	fi
}

python_compile() {
	if python_is_python3; then
		run_in_build_dir distutils-r1_python_compile
	else
		distutils-r1_python_compile
	fi
}

python_install(){
	if python_is_python3; then
		run_in_build_dir distutils-r1_python_install
	else
		distutils-r1_python_install
	fi
}

python_test() {
	if python_is_python3; then
		pushd "${S3}/tests" &> /dev/null
	else
		pushd "${S2}/tests" &> /dev/null
	fi
	"${PYTHON}" utest.py || die "tests failed under ${EPYTHON}"
	einfo "Testsuite passed under ${EPYTHON}"
	popd &> /dev/null
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

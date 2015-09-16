# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 multilib

PN3="${PN}3"
P3="${PN3}-${PV}"

DESCRIPTION="DNS toolkit for Python"
HOMEPAGE="http://www.dnspython.org/ https://pypi.python.org/pypi/dnspython"
SRC_URI="
	http://www.dnspython.org/kits/${PV}/${P}.tar.gz
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

s_locator() {
	if python_is_python3; then
		einfo "Setting \${S} to ${S3}"
		S="${S3}" $@
	else
		einfo "Setting \${S} to ${S2}"
		S="${S2}" $@
	fi
}

python_prepare() {
	s_locator distutils-r1_python_prepare
}

python_compile() {
	s_locator distutils-r1_python_compile
}

python_install(){
	s_locator distutils-r1_python_install
}

my_test() {
	pushd tests &> /dev/null
	"${PYTHON}" utest.py || die "tests failed under ${EPYTHON}"
	einfo "Testsuite passed under ${EPYTHON}"
}

python_test() {
	s_locator my_test
}

python_install() {
	s_locator distutils-r1_python_install
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

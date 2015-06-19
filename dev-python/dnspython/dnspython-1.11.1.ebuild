# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dnspython/dnspython-1.11.1.ebuild,v 1.10 2015/04/08 08:05:28 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="DNS toolkit for Python"
HOMEPAGE="http://www.dnspython.org/ http://pypi.python.org/pypi/dnspython"
SRC_URI="http://www.dnspython.org/kits/${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="examples test"

DEPEND="dev-python/pycrypto[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README )

python_prepare_all() {
	use test && DISTUTILS_IN_SOURCE_BUILD=1
	distutils-r1_python_prepare_all
}

python_test() {
	pushd "${BUILD_DIR}"/../tests &> /dev/null
	local test
	for test in *.py; do
		if ! "${PYTHON}" ${test}; then
			die "test $test failed under ${EPYTHON}"
		else
			einfo "test $test"
		fi
	done
	# make some order out of the output salad
	einfo "Testsuite passed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

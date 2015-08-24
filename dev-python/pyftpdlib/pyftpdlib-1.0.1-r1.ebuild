# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )
PYTHON_REQ_USE="ssl(+)"
# pypy has no spwd.so

inherit distutils-r1

DESCRIPTION="Python FTP server library"
HOMEPAGE="https://code.google.com/p/pyftpdlib/ https://pypi.python.org/pypi/pyftpdlib"
SRC_URI="https://pyftpdlib.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="examples ssl"

DEPEND="ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

DOCS="CREDITS HISTORY"

#PATCHES=( "${FILESDIR}"/${PN}-1-pypy-test.patch )

python_test() {
	cd "${BUILD_DIR}" || die
	for test in "${S}"/test/test_*.py; do
		"${PYTHON}" "${test}" || die "Testing failed with ${EPYTHON}"
	done
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r demo test
	fi
}

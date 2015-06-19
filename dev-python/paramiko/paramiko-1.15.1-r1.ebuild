# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/paramiko/paramiko-1.15.1-r1.ebuild,v 1.11 2015/06/02 05:11:51 jmorgan Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="SSH2 protocol library"
HOMEPAGE="http://www.paramiko.org/ https://github.com/paramiko/paramiko/ http://pypi.python.org/pypi/paramiko/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris"
IUSE="doc examples"

RDEPEND="
	>=dev-python/pycrypto-2.1[${PYTHON_USEDEP}]
	!=dev-python/pycrypto-2.4[${PYTHON_USEDEP}]
	>=dev-python/ecdsa-0.11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# Required for testsuite
DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	"${PYTHON}" test.py --verbose || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	use examples && local EXAMPLES=( demos/. )

	distutils-r1_python_install_all
}

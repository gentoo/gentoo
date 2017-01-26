# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 git-r3

DESCRIPTION="SSH2 protocol library"
HOMEPAGE="http://www.paramiko.org/ https://github.com/paramiko/paramiko/ https://pypi.python.org/pypi/paramiko/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/paramiko/paramiko.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
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
	use examples && dodoc -r demos

	distutils-r1_python_install_all
}

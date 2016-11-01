# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Rolling backport of unittest.mock for all Pythons"
HOMEPAGE="https://github.com/testing-cabal/mock"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"

CDEPEND="
	>=dev-python/pbr-1.3[${PYTHON_USEDEP}]
	>=virtual/python-funcsigs-1[${PYTHON_USEDEP}]"
DEPEND="
	>=dev-python/setuptools-17.1[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/unittest2-1.1.0[${PYTHON_USEDEP}]
	)"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.9[${PYTHON_USEDEP}]
"

python_test() {
	nosetests --verbose || die "tests fail under ${EPYTHON}"
}

python_install_all() {
	local DOCS=( docs/{conf.py,index.txt} AUTHORS ChangeLog NEWS README.rst )

	distutils-r1_python_install_all
}

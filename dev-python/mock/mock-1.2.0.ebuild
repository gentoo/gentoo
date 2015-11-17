# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy )

inherit distutils-r1

DESCRIPTION="Rolling backport of unittest.mock for all Pythons"
HOMEPAGE="https://github.com/testing-cabal/mock"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc test"

CDEPEND="
	>=dev-python/pbr-1.3[${PYTHON_USEDEP}]
	virtual/python-funcsigs[${PYTHON_USEDEP}]"
DEPEND="
	>=dev-python/setuptools-17.1[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/unittest2-1.1.0[${PYTHON_USEDEP}]' python{2_7,3_3} pypy)
	)"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.7[${PYTHON_USEDEP}]
"

python_test() {
	nosetests || die "tests fail under ${EPYTHON}"
}

python_install_all() {
	use doc && local DOCS=( docs/*.txt )

	distutils-r1_python_install_all
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="IRC client framework written in Python"
HOMEPAGE="https://github.com/jaraco/irc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples test"

RDEPEND="
	!>=dev-python/python-irclib-3.2.2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/jaraco-utils[${PYTHON_USEDEP}]"

DEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/hgtools-5[${PYTHON_USEDEP}]
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )"

# A doc folder is present however it appears to be used for doctests

python_test() {
	py.test irc/tests || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( scripts/. )
	distutils-r1_python_install_all
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/Numdifftools/Numdifftools-0.7.7.ebuild,v 1.2 2015/03/12 12:08:35 heroxbd Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

MY_PN=numdifftools
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Solves automatic numerical differentiation problems in one or more variables"
HOMEPAGE="https://pypi.python.org/pypi/Numdifftools http://code.google.com/p/numdifftools/ https://github.com/pbrod/numdifftools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/algopy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	"
DEPEND="test? (
	${RDEPEND}
	dev-python/pytest[${PYTHON_USEDEP}]
	)"

# Seems to be broken
RESTRICT="test"

S="${WORKDIR}"/${MY_P}

python_test() {
	esetup.py test
}

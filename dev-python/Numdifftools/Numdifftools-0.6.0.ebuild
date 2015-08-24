# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Solves automatic numerical differentiation problems in one or more variables"
HOMEPAGE="https://pypi.python.org/pypi/Numdifftools https://code.google.com/p/numdifftools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	"
DEPEND="test? ( ${RDEPEND} )"

# Seems to be broken
RESTRICT="test"

python_test() {
	${PYTHON} \
		-c 'import numdifftools as nd; nd.test(coverage=False, doctests=False)' \
		|| die
}

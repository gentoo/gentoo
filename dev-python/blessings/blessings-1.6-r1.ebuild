# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 24cc890b6e483ab811ab4f3d90918b52192207ec $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="A thin, practical wrapper around terminal coloring, styling, and positioning"
HOMEPAGE="https://github.com/erikrose/blessings https://pypi.python.org/pypi/blessings/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	# The tests need an interactive terminal
	# https://github.com/erikrose/blessings/issues/117
	script -eqc "nosetests -w \"${BUILD_DIR}\"" /dev/null \
		|| die "tests failed with ${EPYTHON}"
}

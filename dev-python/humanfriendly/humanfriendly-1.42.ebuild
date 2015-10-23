# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Human friendly output for text interfaces using Python"
HOMEPAGE="https://pypi.python.org/pypi/humanfriendly https://humanfriendly.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/capturer[${PYTHON_USEDEP}]
		dev-python/coloredlogs[${PYTHON_USEDEP}]
	)
	"
python_test() {
	esetup.py test
}

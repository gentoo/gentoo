# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Human friendly output for text interfaces using Python"
HOMEPAGE="https://pypi.python.org/pypi/humanfriendly https://humanfriendly.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/monotonic[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/capturer-2.1[${PYTHON_USEDEP}]
		>=dev-python/coloredlogs-2.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	"
python_test() {
	esetup.py test
}

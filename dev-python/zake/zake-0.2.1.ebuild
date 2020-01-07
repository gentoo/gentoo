# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Set of testing utilities for the kazoo library"
HOMEPAGE=" https://github.com/yahoo/Zake"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/testtools[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/kazoo[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

python_test() {
	${EPYTHON} -m nose || die
}

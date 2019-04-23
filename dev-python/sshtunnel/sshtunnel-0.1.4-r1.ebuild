# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Pure python SSH tunnels"
HOMEPAGE="https://pypi.python.org/pypi/sshtunnel"
SRC_URI="mirror://pypi/s/sshtunnel/${P}.tar.gz"

KEYWORDS="amd64 ~arm ~x86"
LICENSE="MIT"
SLOT="0"

IUSE="test"

RDEPEND="dev-python/paramiko[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

python_test() {
	py.test --showlocals --cov sshtunnel --durations=10 -n4 tests
}

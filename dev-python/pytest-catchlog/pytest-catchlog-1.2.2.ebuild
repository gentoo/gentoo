# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 pypy3 )

inherit distutils-r1

DESCRIPTION="py.test plugin to catch log messages, fork of pytest-capturelog"
HOMEPAGE="https://pypi.org/project/pytest-catchlog/ https://github.com/eisensheng/pytest-catchlog"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND=">=dev-python/py-1.1.1[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${COMMON_DEPEND}
		>=dev-python/pytest-2.7.1[${PYTHON_USEDEP}]
	)"
RDEPEND="${COMMON_DEPEND}
	!dev-python/pytest-capturelog"

python_test() {
	PYTEST_PLUGINS=${PN/-/_} py.test -v -v test_pytest_catchlog.py || die
}

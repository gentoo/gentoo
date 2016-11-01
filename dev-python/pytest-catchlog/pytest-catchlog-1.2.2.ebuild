# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="py.test plugin to catch log messages, fork of pytest-capturelog"
HOMEPAGE="https://pypi.python.org/pypi/pytest-catchlog https://github.com/eisensheng/pytest-catchlog"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=">=dev-python/py-1.1.1[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.7.1[${PYTHON_USEDEP}]
	)"

python_test() {
	PYTEST_PLUGINS=${PN/-/_} py.test -v -v test_pytest_catchlog.py || die
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="py.test plugin to catch log messages, fork of pytest-capturelog"
HOMEPAGE="https://pypi.python.org/pypi/pytest-catchlog https://github.com/eisensheng/pytest-catchlog"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/eisensheng/pytest-catchlog/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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

# Cannot figure out how to run them
RESTRICT=test

python_test() {
	PYTHONPATH="${S}:${PYTHONPATH}" \
		py.test -v -v -x || die
}

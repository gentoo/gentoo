# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Easily test your HTTP library against a local copy of httpbin"
HOMEPAGE="https://github.com/kevin1024/pytest-httpbin http://pypi.python.org/pypi/pytest-httpbin"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/httpbin[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

# Not includd
RESTRICT=test

python_test() {
	PYTEST_PLUGINS=pytest_httpbin \
		py.test -v -s || die
}

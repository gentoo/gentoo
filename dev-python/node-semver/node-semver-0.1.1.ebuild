# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python version of node-semver, the semantic versioner for npm"
HOMEPAGE="
	https://pypi.python.org/pypi/node-semver
	https://github.com/podhmo/python-semver
	https://github.com/npm/node-semver"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# https://github.com/podhmo/python-semver/issues/4
	sed -i -e "/github.com/d" semver/tests/test_negative_range.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test || die
}

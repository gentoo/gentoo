# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Currently (2020-11-04) rope is blocking
# support for python 3.9.
# For details see
# https://github.com/python-rope/rope/issues/299
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="A helper for using rope refactoring library in IDEs"
HOMEPAGE="https://github.com/python-rope/ropemode https://pypi.org/project/ropemode/"
SRC_URI="https://github.com/python-rope/ropemode/archive/${PV}.tar.gz -> ${P}.tar.gz"
# pypi releases don't include tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/rope[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" ropemodetest.py || die "tests failed with ${EPYTHON}"
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A helper for using rope refactoring library in IDEs"
HOMEPAGE="https://github.com/python-rope/ropemode https://pypi.org/project/ropemode/"
SRC_URI="https://github.com/python-rope/ropemode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/rope[${PYTHON_USEDEP}]"
BDEPEND="test? ( ${RDEPEND} )"

python_test() {
	"${PYTHON}" ropemodetest.py -v || die "tests failed with ${EPYTHON}"
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="py.test plugin for relaxed test discovery and organization"
HOMEPAGE="https://pypi.python.org/pypi/pytest-relaxed https://github.com/bitprophet/pytest-relaxed"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/pytest-3[${PYTHON_USEDEP}]
	>=dev-python/six-1[${PYTHON_USEDEP}]
	>=dev-python/decorator-4[${PYTHON_USEDEP}]
"
DEPEND="test? ( ${RDEPEND} )"

# various misc failures
RESTRICT="test"

python_test() {
	py.test || die "tests failed with ${EPYTHON}"
}

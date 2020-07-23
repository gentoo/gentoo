# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1

DESCRIPTION="Geometric objects, predicates, and operations"
HOMEPAGE="https://pypi.org/project/Shapely/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/geos-3.3
"

BDEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

distutils_enable_sphinx docs

python_test() {
	distutils_install_for_testing
	${EPYTHON} -m pytest tests || die "tests failed under ${EPYTHON}"
}

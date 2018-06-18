# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy{,3} python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="A JavaScript minifier written in Python"
HOMEPAGE="https://slimit.readthedocs.io/en/latest/"
SRC_URI="https://github.com/rspivak/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/ply[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}/${P}-fix-python3.patch" )

python_test() {
	esetup.py pytest --addopts "${BUILD_DIR}" || die "Testing failed with ${EPYTHON}"
}

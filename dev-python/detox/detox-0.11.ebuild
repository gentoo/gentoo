# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="distributed tox"
HOMEPAGE="https://github.com/tox-dev/detox https://pypi.org/project/detox/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/py-1.4.27[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/tox-2[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	py.test -v || die "tests failed under ${EPYTHON}"
}

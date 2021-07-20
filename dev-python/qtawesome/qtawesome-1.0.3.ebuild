# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 virtualx

MY_PN="QtAwesome"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Enables iconic fonts such as Font Awesome in PyQt"
HOMEPAGE="https://github.com/spyder-ide/qtawesome/ https://pypi.org/project/QtAwesome/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-fonts/fontawesome
	dev-python/QtPy[pyqt5(+),gui,${PYTHON_USEDEP}]
"

DEPEND="test? ( dev-python/pytest-qt[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source

src_test() {
	virtx python_foreach_impl python_test
}

python_test() {
	# Tests fail with pyside2, so depend on QtPy[pyqt5] and explicitly run
	# the tests with pyqt5
	PYTEST_QT_API="pyqt5" epytest
}

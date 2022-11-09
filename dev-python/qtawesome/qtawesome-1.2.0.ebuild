# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 virtualx

MY_PN="QtAwesome"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Enables iconic fonts such as Font Awesome in PyQt"
HOMEPAGE="https://github.com/spyder-ide/qtawesome/ https://pypi.org/project/QtAwesome/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-fonts/fontawesome
	dev-python/QtPy[pyqt5(+),gui,${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-python/pytest-qt[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	# Tests fail with pyside2, so depend on QtPy[pyqt5] and explicitly run
	# the tests with pyqt5
	PYTEST_QT_API="pyqt5" epytest || die "Tests failed with ${EPYTHON}"
}

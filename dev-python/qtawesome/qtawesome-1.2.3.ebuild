# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi virtualx

DESCRIPTION="Enables iconic fonts such as Font Awesome in PyQt"
HOMEPAGE="
	https://github.com/spyder-ide/qtawesome/
	https://pypi.org/project/QtAwesome/
"
SRC_URI="$(pypi_sdist_url --no-normalize QtAwesome)"
S="${WORKDIR}/QtAwesome-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	media-fonts/fontawesome
	dev-python/QtPy[pyqt5(+),gui,${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-qt[${PYTHON_USEDEP}]
	)
"

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

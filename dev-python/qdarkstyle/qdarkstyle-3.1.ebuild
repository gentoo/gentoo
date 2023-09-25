# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="QDarkStyle"

inherit distutils-r1 optfeature pypi

DESCRIPTION="A dark style sheet for QtWidgets application"
HOMEPAGE="https://github.com/ColinDuquesnoy/QDarkStyleSheet"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-python/QtPy-1.9[gui,${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/qtsass[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.9[gui,testlib,${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "Retrieve detailed system information and report bugs upstream" dev-python/helpdev
	optfeature "qdarkstyle.utils" dev-python/qtsass dev-python/watchdog
}

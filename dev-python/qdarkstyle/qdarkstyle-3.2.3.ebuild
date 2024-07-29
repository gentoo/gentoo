# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="QDarkStyle"
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="A dark style sheet for QtWidgets application"
HOMEPAGE="
	https://github.com/ColinDuquesnoy/QDarkStyleSheet/
	https://pypi.org/project/QDarkStyle/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	>=dev-python/QtPy-2.0.0[gui,${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/qtsass[${PYTHON_USEDEP}]
		dev-python/watchdog[${PYTHON_USEDEP}]
		>=dev-python/QtPy-2.0.0[gui,testlib,${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

pkg_postinst() {
	optfeature "Retrieve detailed system information and report bugs upstream" dev-python/helpdev
	optfeature "qdarkstyle.utils" dev-python/qtsass dev-python/watchdog
}

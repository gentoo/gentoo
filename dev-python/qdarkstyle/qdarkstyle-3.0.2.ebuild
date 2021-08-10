# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 optfeature

MY_PN="QDarkStyleSheet"

DESCRIPTION="A dark style sheet for QtWidgets application"
HOMEPAGE="https://github.com/ColinDuquesnoy/QDarkStyleSheet"
SRC_URI="https://github.com/ColinDuquesnoy/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

# TODO: Figure out how to get this to work
# Please pass a palette class in order to create its qrc file
RESTRICT="test"

RDEPEND=">=dev-python/QtPy-1.7[gui,${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/qtsass[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.7[gui,testlib,${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_postinst() {
	optfeature "Retrieve detailed system information and report bugs upstream" dev-python/helpdev
	optfeature "qdarkstyle.utils" dev-python/qtsass dev-python/watchdog
}

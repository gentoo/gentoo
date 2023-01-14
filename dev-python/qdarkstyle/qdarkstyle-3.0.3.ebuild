# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 optfeature

MY_PN="QDarkStyle"

DESCRIPTION="A dark style sheet for QtWidgets application"
HOMEPAGE="https://github.com/ColinDuquesnoy/QDarkStyleSheet"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

# TODO: Figure out how to get this to work
# Please pass a palette class in order to create its qrc file
# This appears to be fundamentally broken: test calls create_qss() without
# argument and that function does sys.exit(1) if the argument is None.
RESTRICT="test"

RDEPEND=">=dev-python/QtPy-1.7[gui,${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/qtsass[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.7[gui,testlib,${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "Retrieve detailed system information and report bugs upstream" dev-python/helpdev
	optfeature "qdarkstyle.utils" dev-python/qtsass dev-python/watchdog
}

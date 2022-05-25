# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 optfeature

MY_PN="QDarkStyle"

DESCRIPTION="A dark style sheet for QtWidgets application"
HOMEPAGE="https://github.com/ColinDuquesnoy/QDarkStyleSheet"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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

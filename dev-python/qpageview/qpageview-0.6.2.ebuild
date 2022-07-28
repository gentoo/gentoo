# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature

DESCRIPTION="Page-based viewer widget for Qt5/PyQt5"
HOMEPAGE="https://qpageview.org/"
SRC_URI="https://github.com/frescobaldi/qpageview/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

# GPL-2+ added here because of https://github.com/frescobaldi/qpageview/issues/15
# Should be GPL-3+ once cleared up
LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="dev-python/PyQt5[gui,printsupport,svg,widgets,${PYTHON_USEDEP}]
	dev-python/python-poppler-qt5[${PYTHON_USEDEP}]"

pkg_postinst() {
	optfeature "Printing support" dev-python/pycups
}

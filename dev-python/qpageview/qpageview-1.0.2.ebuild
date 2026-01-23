# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 optfeature pypi

DESCRIPTION="Page-based viewer widget for Qt5/PyQt5"
HOMEPAGE="https://qpageview.org/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyqt6[gui,pdfium,printsupport,svg,widgets,${PYTHON_USEDEP}]
"

pkg_postinst() {
	optfeature "printing support" dev-python/pycups
}

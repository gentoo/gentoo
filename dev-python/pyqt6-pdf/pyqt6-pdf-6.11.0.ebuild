# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# match with dev-python/pyqt6
PYQT6_PYTHON_USE=( python_targets_python3_{12..15} )

DESCRIPTION="Python bindings for QtPdf"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtpdf/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="debug ${PYQT6_PYTHON_USE[*]} +widgets"

RDEPEND="
	=dev-python/pyqt6-6.11*[debug?,pdfium,widgets?$(printf ',%s(-)?' "${PYQT6_PYTHON_USE[@]}")]
"

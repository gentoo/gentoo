# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="An optical character recognition (OCR) tool wrapper"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork/pyocr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuneiform +tesseract"
REQUIRED_USE="|| ( cuneiform tesseract )"

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]"

# (tests apparently do not require any backend installed)
distutils_enable_tests unittest

RDEPEND+="
	cuneiform? ( app-text/cuneiform )
	tesseract? ( app-text/tesseract )"

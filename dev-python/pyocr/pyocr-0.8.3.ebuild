# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="An optical character recognition (OCR) tool wrapper"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork/pyocr"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuneiform +tesseract"
REQUIRED_USE="|| ( cuneiform tesseract )"

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
"

# (tests apparently do not require any backend installed)
distutils_enable_tests unittest

RDEPEND+="
	cuneiform? ( app-text/cuneiform )
	tesseract? ( app-text/tesseract )
"

src_prepare() {
	# workaround setuptools failing due to version being None
	# https://gitlab.gnome.org/World/OpenPaperwork/pyocr/-/issues/127
	sed -i -e '/version=version/d' setup.py || die
	distutils-r1_src_prepare
}

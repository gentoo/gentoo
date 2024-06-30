# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Optical character recognition (OCR) tool"
HOMEPAGE="
	https://github.com/madmaze/pytesseract/
	https://pypi.org/project/pytesseract/
"
SRC_URI="
	https://github.com/madmaze/pytesseract/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	app-text/tesseract
"
BDEPEND="
	test? (
		app-text/tesseract[jpeg,png,tiff,webp]
		media-libs/leptonica[gif,jpeg2k]
		app-text/tessdata_fast[l10n_fr]
		dev-python/pillow[jpeg,zlib]
	)
"

distutils_enable_tests pytest

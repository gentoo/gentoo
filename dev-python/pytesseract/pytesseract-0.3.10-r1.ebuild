# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Optical character recognition (OCR) tool"
HOMEPAGE="https://github.com/madmaze/pytesseract"
SRC_URI="https://github.com/madmaze/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pillow[${PYTHON_USEDEP}]
	app-text/tesseract"
BDEPEND="
	test? (
		app-text/tesseract[jpeg,png,tiff,webp]
		media-libs/leptonica[gif,jpeg2k]
		app-text/tessdata_fast[l10n_fr]
		dev-python/pillow[jpeg,zlib]
	)
"

distutils_enable_tests pytest

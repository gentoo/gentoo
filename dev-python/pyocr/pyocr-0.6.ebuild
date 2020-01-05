# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="An optical character recognition (OCR) tool wrapper for python"
HOMEPAGE="https://github.com/openpaperwork/pyocr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
IUSE="cuneiform +tesseract"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="cuneiform? ( app-text/cuneiform )
	tesseract? ( app-text/tesseract )
	dev-python/pillow
	dev-python/six"
DEPEND="${RDEPEND}"

REQUIRED_USE="|| ( cuneiform tesseract )"

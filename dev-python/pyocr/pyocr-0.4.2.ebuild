# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="An optical character recognition (OCR) tool wrapper for python"
HOMEPAGE="https://github.com/jflesch/pyocr"
SRC_URI="https://github.com/jflesch/pyocr/archive/${PV}.tar.gz -> ${P}.tar.gz"

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

RESTRICT="test" # reguires tesseract[l10n_fr,l10n_en,l10n_jp]

python_test() {
	${EPYTHON} run_tests.py || die
}

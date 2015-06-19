# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyocr/pyocr-0.2.4.ebuild,v 1.2 2014/11/27 15:01:32 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="an optical character recognition (OCR) tool wrapper for python"
HOMEPAGE="https://github.com/jflesch/pyocr"
SRC_URI="https://github.com/jflesch/pyocr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
IUSE="cuneiform +tesseract"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="cuneiform? ( app-text/cuneiform )
	tesseract? ( app-text/tesseract )
	virtual/python-imaging"
DEPEND="${RDEPEND}"

REQUIRED_USE="|| ( cuneiform tesseract )"

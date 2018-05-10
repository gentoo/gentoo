# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Read one-dimensional barcodes and QR codes from Python."
HOMEPAGE="https://github.com/NaturalHistoryMuseum/pyzbar/"
SRC_URI="https://github.com/NaturalHistoryMuseum/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-gfx/zbar
	dev-python/pillow
	dev-python/numpy
	python_targets_python2_7? (
		=dev-python/enum34-1.1.6
		virtual/python-pathlib
	)
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

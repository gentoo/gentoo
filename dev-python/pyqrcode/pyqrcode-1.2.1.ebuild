# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5})

inherit distutils-r1

MY_PN="PyQRCode"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A pure Python QR code generator with SVG, EPS, PNG and terminal output"
HOMEPAGE="https://github.com/mnooner256/pyqrcode https://pypi.python.org/pypi/PyQRCode"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="png"

RDEPEND="
	png? ( dev-python/pypng[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_P}

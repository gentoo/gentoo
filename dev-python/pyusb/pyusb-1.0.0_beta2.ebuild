# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_P="${P/_beta/b}"

DESCRIPTION="USB support for Python"
HOMEPAGE="http://pyusb.sourceforge.net/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

### This version is compatible with both 0.X and 1.X versions of libusb
DEPEND="virtual/libusb
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS="README.rst docs/tutorial.rst"

S="${WORKDIR}/${MY_P}"

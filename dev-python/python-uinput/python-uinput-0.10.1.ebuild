# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=(python{2_7,3_4})

inherit distutils-r1

DESCRIPTION="Pythonic API to the Linux uinput kernel module"
HOMEPAGE="http://tjjr.fi/sw/python-uinput/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/udev"
RDEPEND="${DEPEND}"

python_prepare_all() {
	sed \
		-e "s:libudev.so.0:libudev.so:g" \
		-i setup.py || die
	rm libsuinput/src/libudev.h || die
	distutils-r1_python_prepare_all
}

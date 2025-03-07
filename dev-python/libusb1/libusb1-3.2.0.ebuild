# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} python3_13t )

inherit distutils-r1

DESCRIPTION="Python ctype-based wrapper around libusb1"
HOMEPAGE="https://github.com/vpelletier/python-libusb1"
SRC_URI="https://github.com/vpelletier/python-libusb1/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="virtual/libusb:1"
DEPEND="test? ( ${RDEPEND} )"

distutils_enable_tests unittest

src_prepare() {
	# Don't need this.
	rm -r usb1/__pyinstaller || die
	default
}

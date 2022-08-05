# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Python binding for LeechCore Physical Memory Acquisition Library"
HOMEPAGE="https://github.com/ufrisk/LeechCore"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# leechcorepyc ships with a bundled version of the LeechCore library. So we
# don't depend on the library here. But we must be aware this module doesn't
# use the system library.
DEPEND="virtual/libusb:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.12.0-respect-CC.patch
)

src_configure() {
	tc-export CC

	distutils-r1_src_configure
}

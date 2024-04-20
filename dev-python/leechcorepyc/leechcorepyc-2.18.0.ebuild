# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 toolchain-funcs pypi

DESCRIPTION="Python binding for LeechCore Physical Memory Acquisition Library"
HOMEPAGE="https://github.com/ufrisk/LeechCore"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

# leechcorepyc ships with a bundled version of the LeechCore library. So we
# don't depend on the library here. But we must be aware this module doesn't
# use the system library.
DEPEND="virtual/libusb:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-2.16.9-respect-CC.patch"
)

src_prepare() {
	default

	# Avoid redefining _FORTIFY_SOURCE. See #893824, #906715.
	sed -i -e 's/ -D_FORTIFY_SOURCE=2 / /g' leechcore/Makefile || die
}

src_configure() {
	tc-export CC

	distutils-r1_src_configure
}

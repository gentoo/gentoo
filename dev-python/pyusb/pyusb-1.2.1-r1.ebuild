# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="USB support for Python"
HOMEPAGE="https://pyusb.github.io/pyusb/ https://pypi.org/project/pyusb/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

### This version is compatible with both 0.X and 1.X versions of libusb
DEPEND="virtual/libusb:="
RDEPEND="${DEPEND}"

DOCS=( README.rst docs/tutorial.rst )

PATCHES=(
	"${FILESDIR}"/${P}-setuptools.patch
)

python_test() {
	cd tests || die
	"${EPYTHON}" testall.py || die "Tests failed with ${EPYTHON}"
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="USB support for Python"
HOMEPAGE="https://pyusb.github.io/pyusb/ https://pypi.org/project/pyusb/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"

### This version is compatible with both 0.X and 1.X versions of libusb
DEPEND="virtual/libusb:="
RDEPEND="${DEPEND}"

DOCS=( README.rst docs/tutorial.rst )

python_test() {
	cd tests || die
	"${EPYTHON}" testall.py || die "Tests failed with ${EPYTHON}"
}

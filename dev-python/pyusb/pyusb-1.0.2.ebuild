# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="USB support for Python"
HOMEPAGE="https://pyusb.github.io/pyusb/ https://pypi.org/project/pyusb/"
SRC_URI="https://github.com/walac/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# pypi releases don't include tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"
IUSE=""

### This version is compatible with both 0.X and 1.X versions of libusb
DEPEND="virtual/libusb:=
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS="README.rst docs/tutorial.rst"

python_test() {
	cd tests || die
	"${PYTHON}" testall.py || die "Tests failed with ${EPYTHON}"
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

# upstream doesn't do tags
EGIT_COMMIT="674a77b5eaf850d063f518bd90c243ee34ad6b5d"

DESCRIPTION="A pure Python QR code generator with SVG, EPS, PNG and terminal output"
HOMEPAGE="
	https://github.com/mnooner256/pyqrcode/
	https://pypi.org/project/PyQRCode/
"
SRC_URI="
	https://github.com/mnooner256/pyqrcode/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="png"

RDEPEND="
	png? ( dev-python/pypng[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? ( dev-python/pypng[${PYTHON_USEDEP}] )
"

distutils_enable_tests nose

src_prepare() {
	# don't pull in tkinter for one test
	sed -i -e 's:test_xbm_with_tkinter:_&:' \
		tests/test_xbm.py || die

	distutils-r1_src_prepare
}

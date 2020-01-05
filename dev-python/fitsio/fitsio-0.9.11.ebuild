# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Python library to read from and write to FITS files"
HOMEPAGE="https://github.com/esheldon/fitsio"
SRC_URI="https://github.com/esheldon/fitsio/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-python/numpy-1.11[${PYTHON_USEDEP}]
	sci-libs/cfitsio:0=
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${P}-test-failures.patch )

python_prepare_all() {
	sed -e '/self.use_system_fitsio/s/False/True/' \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	pushd "${TEST_DIR}"/ || die
	${PYTHON} -c "import fitsio; exit(fitsio.test.test())" || die
	popd > /dev/null || die
}

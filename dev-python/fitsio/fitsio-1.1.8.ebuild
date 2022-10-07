# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Python library to read from and write to FITS files"
HOMEPAGE="https://github.com/esheldon/fitsio"
SRC_URI="
	https://github.com/esheldon/fitsio/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.11[${PYTHON_USEDEP}]
	sci-libs/cfitsio:0=
"
BDEPEND="${RDEPEND}"

src_configure() {
	cat >> setup.cfg <<-EOF || die
		[build_ext]
		use_system_fitsio = True
	EOF
}

python_test() {
	cd "${T}" || die
	"${EPYTHON}" -c "import fitsio; exit(fitsio.test.test())" ||
		die "Tests failed with ${EPYTHON}"
}

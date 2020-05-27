# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Python Serial Port extension"
HOMEPAGE="https://github.com/pyserial/pyserial https://pypi.org/project/pyserial/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="examples"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

DOCS=( CHANGES.rst README.rst )

distutils_enable_sphinx documentation --no-autodoc

python_test() {
	"${EPYTHON}" test/run_all_tests.py loop:// -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

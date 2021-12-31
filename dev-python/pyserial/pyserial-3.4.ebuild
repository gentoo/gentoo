# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy )

inherit distutils-r1

DESCRIPTION="Python Serial Port extension"
HOMEPAGE="https://github.com/pyserial/pyserial https://pypi.org/project/pyserial/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc examples"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )
"

# Usual avoid d'loading un-needed objects.inv file
PATCHES=( "${FILESDIR}"/mapping.patch )

DOCS=( CHANGES.rst README.rst )

python_compile_all() {
	use doc && emake -C documentation html
}

python_test() {
	"${EPYTHON}" test/run_all_tests.py loop:// -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( documentation/_build/html/. )
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=no
DISTUTILS_EXT=1

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Object-oriented python bindings for subversion"
HOMEPAGE="https://pysvn.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/project/pysvn/pysvn/V${PV}/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="doc examples"

DEPEND="
	>=dev-python/pycxx-7.1.8[${PYTHON_USEDEP}]
	>=dev-vcs/subversion-1.9"
RDEPEND="${DEPEND}"

python_prepare_all() {
	# Don't use internal copy of dev-python/pycxx.
	rm -r Import || die

	distutils-r1_python_prepare_all
}

python_configure() {
	cd Source || die
	CC="$(tc-getCC)" CCC="$(tc-getCXX)" \
		esetup.py configure
}

python_compile() {
	cd Source || die
	emake
}

python_test() {
	cd Tests || die
	emake
}

python_install() {
	cd Source || die
	python_domodule pysvn
}

python_install_all() {
	use doc && local HTML_DOCS=( Docs/. )
	if use examples; then
		docinto examples
		dodoc -r Examples/Client/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}

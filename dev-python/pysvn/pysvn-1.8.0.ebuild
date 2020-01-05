# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_6} )

inherit eutils distutils-r1 toolchain-funcs

DESCRIPTION="Object-oriented python bindings for subversion"
HOMEPAGE="http://pysvn.tigris.org/"
SRC_URI="http://pysvn.barrys-emacs.org/source_kits/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="doc examples"

DEPEND="
	>=dev-python/pycxx-6.2.6[${PYTHON_USEDEP}]
	dev-vcs/subversion"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-respect_flags.patch )

DISTUTILS_IN_SOURCE_BUILD=true

python_prepare_all() {
	# Don't use internal copy of dev-python/pycxx.
	rm -r Import || die

	distutils-r1_python_prepare_all
}

python_configure() {
	cd Source || die
	# all config options from 1.7.6 are all already set
	esetup.py configure
}

python_compile() {
	cd Source || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
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
	use examples && local EXAMPLES=( Examples/Client/. )
	distutils-r1_python_install_all
}

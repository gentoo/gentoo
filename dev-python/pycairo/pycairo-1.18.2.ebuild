# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 python3_{6..9} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python bindings for the cairo library"
HOMEPAGE="https://www.cairographics.org/pycairo/ https://github.com/pygobject/pycairo"
SRC_URI="https://github.com/pygobject/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/hypothesis[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		' -3)
	)
"
RDEPEND="
	>=x11-libs/cairo-1.13.1[svg]
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.19.1-py39.patch" )

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
distutils_enable_tests setup.py

python_test() {
	if ! python_is_python3; then
		einfo "Skipping tests on Python 2 to unblock deps"
		return
	fi

	esetup.py test
}

python_install() {
	distutils-r1_python_install \
		install_pkgconfig --pkgconfigdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig"
}

python_install_all() {
	if use examples; then
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}

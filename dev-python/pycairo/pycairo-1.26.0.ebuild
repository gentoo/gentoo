# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python bindings for the cairo library"
HOMEPAGE="
	https://www.cairographics.org/pycairo/
	https://github.com/pygobject/pycairo/
	https://pypi.org/project/pycairo/
"
SRC_URI="
	https://github.com/pygobject/${PN}/releases/download/v${PV}/${P}.tar.gz
"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples"

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=x11-libs/cairo-1.15.10[svg(+)]
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

python_test() {
	esetup.py build_tests
	epytest
}

python_install() {
	distutils-r1_python_install

	# we need to pass --root via install command, sigh
	cat > "${T}/distutils-extra.cfg" <<-EOF || die
		[install]
		root = ${D}
	EOF
	local -x DIST_EXTRA_CONFIG=${T}/distutils-extra.cfg
	esetup.py \
		install_pkgconfig --pkgconfigdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig"
}

python_install_all() {
	if use examples; then
		dodoc -r examples
	fi

	distutils-r1_python_install_all

	insinto /usr/include/pycairo
	doins cairo/py3cairo.h
}

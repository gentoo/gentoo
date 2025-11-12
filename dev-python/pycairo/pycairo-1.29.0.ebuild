# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
# TODO: readd 3.13t & 3.14t (requires same in meson-python)
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="X examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=x11-libs/cairo-1.15.10[svg(+),X?]
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	virtual/pkgconfig
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

src_configure() {
	DISTUTILS_ARGS=(
		-Dtests="$(usex test true false)"
		-Dno-x11="$(usex X false true)"
	)
}

python_test() {
	rm -rf cairo || die
	epytest
}

python_install_all() {
	if use examples; then
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
# we aren't using meson-python, as that results in removing .pc file
# https://bugs.gentoo.org/966038
DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{11..12} python3_{13..14}{,t} pypy3_11 )
PYTHON_REQ_USE="threads(+)"

inherit meson distutils-r1

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
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
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

python_compile() {
	local emesonargs=(
		# TODO: move that to the eclass?
		-Dpython.bytecompile=2
		-Dtests="$(usex test true false)"
		-Dno-x11="$(usex X false true)"
	)

	meson_src_configure
	meson_src_compile
}

python_test() {
	cd "${BUILD_DIR}" || die
	epytest
}

python_install() {
	meson_src_install
}

python_install_all() {
	if use examples; then
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}

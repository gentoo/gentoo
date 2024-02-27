# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi virtualx

DESCRIPTION="CFFI-based drop-in replacement for Pycairo"
HOMEPAGE="
	https://github.com/Kozea/cairocffi/
	https://pypi.org/project/cairocffi/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

DEPEND="
	>=dev-python/xcffib-0.3.2[${PYTHON_USEDEP}]
	x11-libs/cairo:0=[X,xcb(+)]
	x11-libs/gdk-pixbuf[jpeg]
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]
	' 'python*')
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]
	' 'python*')
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pikepdf[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.0-tests.patch
)

src_test() {
	virtx distutils-r1_src_test
}

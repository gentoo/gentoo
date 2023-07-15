# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="A drop in replacement for xpyb, an XCB python binding"
HOMEPAGE="
	https://github.com/tych0/xcffib/
	https://pypi.org/project/xcffib/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ppc64 ~riscv ~s390 sparc x86"

DEPEND="
	x11-libs/libxcb
"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.1:=[${PYTHON_USEDEP}]
	' 'python*')
	${DEPEND}
"
BDEPEND="
	test? (
		x11-base/xorg-server[xvfb]
		x11-apps/xeyes
	)
"

distutils_enable_tests pytest

python_test() {
	rm -rf xcffib || die
	epytest
}

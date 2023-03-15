# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 virtualx pypi

DESCRIPTION="A cross-platform clipboard module for Python"
HOMEPAGE="
	https://github.com/asweigart/pyperclip/
	https://pypi.org/project/pyperclip/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	|| (
		x11-misc/xsel
		x11-misc/xclip
		kde-plasma/plasma-workspace
		dev-python/PyQt5[${PYTHON_USEDEP}]
		dev-python/QtPy[${PYTHON_USEDEP}]
	)
"
# test at least one backend
BDEPEND="
	test? (
		${RDEPEND}
	)
"

src_prepare() {
	# stupid windows
	find -type f -exec sed -i -e 's:\r$::' {} + || die
	# klipper is hard to get working, and once we make it work,
	# it breaks most of the other backends
	# wl-copy requires wayland, not Xvfb
	sed -e 's:_executable_exists("\(klipper\|wl-copy\)"):False:' \
		-i tests/test_pyperclip.py || die
	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" tests/test_pyperclip.py -vv ||
		die "Tests fail on ${EPYTHON}"
}

src_test() {
	virtx distutils-r1_src_test
}

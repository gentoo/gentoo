# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1 optfeature pypi

DESCRIPTION="Curses-based user interface library for Python"
HOMEPAGE="
	https://urwid.org/
	https://pypi.org/project/urwid/
	https://github.com/urwid/urwid/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	rm -rf urwid || die
	eunittest
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Trio event loop" "dev-python/trio"
}

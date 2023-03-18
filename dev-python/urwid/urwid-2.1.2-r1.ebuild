# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
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
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

distutils_enable_sphinx docs
distutils_enable_tests setup.py

PATCHES=(
	# https://github.com/urwid/urwid/pull/517
	"${FILESDIR}/${P}-fix-py3.11.patch"
)

src_prepare() {
	# optional tests broken by modern tornado versions
	sed -e 's:import tornado:&_broken:' \
		-i urwid/tests/test_event_loops.py || die

	# Fix doc generation
	sed -e 's/!defindex/layout/' -i docs/tools/templates/indexcontent.html || die

	# Fix for >=dev-python/trio-0.15
	sed -e 's/hazmat/lowlevel/' -i urwid/_async_kw_event_loop.py || die

	distutils-r1_src_prepare
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Trio event loop" "dev-python/trio"
}

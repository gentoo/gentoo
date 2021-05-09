# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="Curses-based user interface library for Python"
HOMEPAGE="http://urwid.org/ https://pypi.org/project/urwid/ https://github.com/urwid/urwid/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.1-ignore-resetting-to-invalid-locale.patch"
)

distutils_enable_sphinx docs
distutils_enable_tests setup.py

src_prepare() {
	# optional tests broken by modern tornado versions
	sed -e 's:import tornado:&_broken:' \
		-i urwid/tests/test_event_loops.py || die
	distutils-r1_src_prepare
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}

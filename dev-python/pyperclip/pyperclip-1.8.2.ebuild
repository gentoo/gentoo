# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1 virtualx

DESCRIPTION="A cross-platform clipboard module for Python."
HOMEPAGE="https://github.com/asweigart/pyperclip"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc64 ~sparc ~x86"

RDEPEND="
	|| (
		(
			x11-misc/xsel
			sys-apps/which
		)
		(
			x11-misc/xclip
			sys-apps/which
		)
		(
			kde-plasma/plasma-workspace
			sys-apps/which
		)
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
	sed -e 's:_executable_exists("klipper"):False:' \
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

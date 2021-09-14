# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 virtualx

DESCRIPTION="Extra features for standard library's cmd module"
HOMEPAGE="https://github.com/python-cmd2/cmd2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/pyperclip-1.6[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
# pyperclip uses clipboard backends in the following preference order:
# pygtk, xclip, xsel, klipper, qtpy, pyqt5, pyqt4.
# klipper is known to be broken in Xvfb, and therefore causes test
# failures.  to avoid them, we must ensure that one of the backends
# preferred to it is available (i.e. xclip or xsel) + which(1).
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		sys-apps/which
		|| (
			x11-misc/xclip
			x11-misc/xsel
		)
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e '/--cov/d' setup.cfg || die
}

src_test() {
	# tests rely on very specific text wrapping...
	local -x COLUMNS=80
	virtx distutils-r1_src_test
}

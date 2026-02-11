# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 optfeature virtualx pypi

DESCRIPTION="Extra features for standard library's cmd module"
HOMEPAGE="
	https://github.com/python-cmd2/cmd2/
	https://pypi.org/project/cmd2/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc64 ~riscv ~s390 ~x86"

RDEPEND="
	>=dev-python/pyperclip-1.8.2[${PYTHON_USEDEP}]
	>=dev-python/rich-14.3.0[${PYTHON_USEDEP}]
	>=dev-python/rich-argparse-1.7.1[${PYTHON_USEDEP}]
"
# pyperclip uses clipboard backends in the following preference order:
# pygtk, xclip, xsel, klipper, qtpy, pyqt5, pyqt4.
# klipper is known to be broken in Xvfb, and therefore causes test
# failures.  to avoid them, we must ensure that one of the backends
# preferred to it is available (i.e. xclip or xsel).
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		|| (
			x11-misc/xclip
			x11-misc/xsel
		)
	)
"

EPYTEST_PLUGINS=( pytest-mock )
EPYTEST_RERUNS=5
distutils_enable_tests pytest

src_test() {
	# tests rely on very specific text wrapping...
	local -x COLUMNS=80
	virtx distutils-r1_src_test
}

python_test() {
	# TODO: tests_isolated?
	nonfatal epytest -o addopts= tests || die
}

pkg_postinst() {
	optfeature "IPython shell integration" dev-python/ipython
}

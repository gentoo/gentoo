# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A goodie-bag of unix shell and environment tools for py.test"
HOMEPAGE="
	https://github.com/man-group/pytest-plugins/
	https://pypi.org/project/pytest-shutil/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/execnet[${PYTHON_USEDEP}]
	dev-python/path[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	dev-python/setuptools-git[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/man-group/pytest-plugins/pull/219
	"${FILESDIR}"/${P}-py312.patch
)

EPYTEST_DESELECT=(
	# colors no longer happen automagically to non-tty, not important
	# https://github.com/man-group/pytest-plugins/pull/217
	tests/unit/test_cmdline.py::test_pretty_formatter
)

python_prepare_all() {
	# remove unnecessary deps
	# (contextlib2 is not used in py3)
	sed -i -e '/path\.py/d' -e '/contextlib2/d' setup.py || die

	distutils-r1_python_prepare_all
}

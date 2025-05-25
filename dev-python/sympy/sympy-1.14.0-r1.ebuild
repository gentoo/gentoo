# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 virtualx

DESCRIPTION="Computer Algebra System in pure Python"
HOMEPAGE="
	https://www.sympy.org/
	https://github.com/sympy/sympy/
	https://pypi.org/project/sympy/
"
# pypi sdist misses some files, notably top-level conftest.py, as of 1.12.1_rc1
SRC_URI="
	https://github.com/sympy/sympy/archive/${PV/_/}.tar.gz
		-> ${P/_/}.gh.tar.gz
"
S=${WORKDIR}/${P/_/}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="imaging ipython latex mathml pdf png pyglet symengine texmacs"

RDEPEND="
	>=dev-python/mpmath-1.1.0[${PYTHON_USEDEP}]
	imaging? ( dev-python/pillow[${PYTHON_USEDEP}] )
	ipython? (
		dev-python/ipython[${PYTHON_USEDEP}]
	)
	latex? (
		virtual/latex-base
		dev-texlive/texlive-fontsextra
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl )
	)
	mathml? ( dev-python/lxml[${PYTHON_USEDEP}] )
	pyglet? ( dev-python/pyglet[${PYTHON_USEDEP}] )
	symengine? ( dev-python/symengine[${PYTHON_USEDEP}] )
	texmacs? ( app-office/texmacs )
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# fix the version number
	sed -i -e "/__version__/s:\".*\":\"${PV}\":" sympy/release.py || die
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# require old version of antlr4, also deprecated
		# https://github.com/sympy/sympy/issues/27026
		sympy/parsing/tests/test_autolev.py
		sympy/parsing/tests/test_latex.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	nonfatal epytest --veryquickcheck ||
		die -n "Tests failed with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( AUTHORS README.md )

	distutils-r1_python_install_all

	if use texmacs; then
		exeinto /usr/libexec/TeXmacs/bin/
		doexe data/TeXmacs/bin/tm_sympy
		insinto /usr/share/TeXmacs/plugins/sympy/
		doins -r data/TeXmacs/progs
	fi
}

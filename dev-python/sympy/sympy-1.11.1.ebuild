# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 virtualx

DESCRIPTION="Computer Algebra System in pure Python"
HOMEPAGE="https://www.sympy.org/"
SRC_URI="https://github.com/sympy/sympy/archive/${P}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="aesara examples imaging ipython latex mathml opengl pdf png pyglet symengine test texmacs"

RDEPEND="
	dev-python/mpmath[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	aesara? ( dev-python/aesara[${PYTHON_USEDEP}] )
	imaging? ( dev-python/pillow[${PYTHON_USEDEP}] )
	ipython? ( dev-python/ipython[${PYTHON_USEDEP}] )
	latex? (
		virtual/latex-base
		dev-texlive/texlive-fontsextra
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl )
	)
	mathml? ( dev-libs/libxml2:2[${PYTHON_USEDEP}] )
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
	pyglet? ( dev-python/pyglet[${PYTHON_USEDEP}] )
	symengine? ( dev-python/symengine[${PYTHON_USEDEP}] )
	texmacs? ( app-office/texmacs )
"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	esetup.py test
}

python_install_all() {
	local DOCS=( AUTHORS README.md )

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all

	if use texmacs; then
		exeinto /usr/libexec/TeXmacs/bin/
		doexe data/TeXmacs/bin/tm_sympy
		insinto /usr/share/TeXmacs/plugins/sympy/
		doins -r data/TeXmacs/progs
	fi
}

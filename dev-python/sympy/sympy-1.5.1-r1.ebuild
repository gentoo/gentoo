# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1 eutils virtualx

DESCRIPTION="Computer Algebra System in pure Python"
HOMEPAGE="https://sympy.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples imaging ipython latex mathml opengl pdf png pyglet symengine test texmacs theano"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	ipython? ( || ( $(python_gen_useflags -3) ) )"

RESTRICT="test"
# All tests actually pass, except a bunch of tests related to the deprecated pygletplot
# It is a non-trivial work to wipe out all such tests :-(

RDEPEND="dev-python/mpmath[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	imaging? ( dev-python/pillow[${PYTHON_USEDEP}] )
	ipython? ( $(python_gen_cond_dep 'dev-python/ipython[${PYTHON_USEDEP}]' -3) )
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
	theano? ( dev-python/theano[${PYTHON_USEDEP}] )
"

DEPEND="${RDEPEND}
	test? ( ${RDEPEND} dev-python/pytest[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${PN}-${P}"

python_test() {
	virtx "${PYTHON}" setup.py test
}

python_install_all() {
	local DOCS=( AUTHORS README.rst )
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

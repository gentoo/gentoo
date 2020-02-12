# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1 eutils virtualx

DESCRIPTION="Computer Algebra System in pure Python"
HOMEPAGE="https://sympy.org"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples gtk imaging ipython latex mathml opengl pdf png test texmacs"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	ipython? ( || ( $(python_gen_useflags -3) ) )"

RDEPEND="dev-python/mpmath[${PYTHON_USEDEP}]
	imaging? ( dev-python/pillow[${PYTHON_USEDEP}] )
	ipython? ( $(python_gen_cond_dep 'dev-python/ipython[${PYTHON_USEDEP}]' -3) )
	latex? (
		virtual/latex-base
		dev-texlive/texlive-fontsextra
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl )
	)
	mathml? (
		dev-libs/libxml2:2[${PYTHON_USEDEP}]
		gtk? ( x11-libs/gtkmathview[gtk] )
	)
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
	texmacs? ( app-office/texmacs )
"

DEPEND="${RDEPEND}
	test? ( ${RDEPEND} dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	epatch "${FILESDIR}"/${P}-doc-makefile.patch
	epatch "${FILESDIR}"/${P}-zeta.patch
	distutils-r1_python_prepare_all
}

python_compile() {
	PYTHONPATH="." distutils-r1_python_compile
}

python_test() {
	virtx "${PYTHON}" setup.py test
}

python_install() {
	PYTHONPATH="." distutils-r1_python_install
}

python_install_all() {
	local DOCS=( AUTHORS README.rst )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all

	if use texmacs; then
		exeinto /usr/libexec/TeXmacs/bin/
		doexe data/TeXmacs/bin/tm_sympy
		insinto /usr/share/TeXmacs/plugins/sympy/
		doins -r data/TeXmacs/progs
	fi
}

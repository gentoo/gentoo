# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1 eutils virtualx

DESCRIPTION="Computer Algebra System in pure Python"
HOMEPAGE="http://sympy.org"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz
	https://dev.gentoo.org/~bicatali/distfiles/${P}-system-mpmath.patch.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="doc examples gtk imaging ipython latex mathml opengl pdf png pyglet +system-mpmath test texmacs theano"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/pexpect-2.0[${PYTHON_USEDEP}]' python2_7)
	imaging? ( virtual/python-imaging[${PYTHON_USEDEP}] )
	ipython? ( dev-python/ipython[${PYTHON_USEDEP}] )
	latex? (
		virtual/latex-base
		dev-texlive/texlive-fontsextra
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl )
	)
	mathml? (
		dev-libs/libxml2:2[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-libs/libxslt[${PYTHON_USEDEP}]' python2_7)
		gtk? ( x11-libs/gtkmathview[gtk] )
	)
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
	pyglet? ( $(python_gen_cond_dep 'dev-python/pyglet[${PYTHON_USEDEP}]' python2_7) )
	system-mpmath? ( >=dev-python/mpmath-0.18[${PYTHON_USEDEP}] )
	texmacs? ( app-office/texmacs )
	theano? ( $(python_gen_cond_dep 'dev-python/theano[${PYTHON_USEDEP}]' python2_7) )
"

DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND} dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	if use system-mpmath; then
		rm -r sympy/mpmath doc/src/modules/mpmath || die
		epatch "${WORKDIR}"/${P}-system-mpmath.patch
	fi
	distutils-r1_python_prepare_all
}

python_compile() {
	PYTHONPATH="." distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		export XDG_CONFIG_HOME="${T}/config-dir"
		mkdir "${XDG_CONFIG_HOME}" || die
		chmod 0700 "${XDG_CONFIG_HOME}" || die
		emake -C doc html cheatsheet
	fi
}

python_test() {
	 VIRTUALX_COMMAND="./setup.py" virtualmake test
}

python_install() {
	PYTHONPATH="." distutils-r1_python_install
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/. ) && \
		dodoc doc/_build/cheatsheet/cheatsheet.pdf
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all

	if use texmacs; then
		exeinto /usr/libexec/TeXmacs/bin/
		doexe data/TeXmacs/bin/tm_sympy
		insinto /usr/share/TeXmacs/plugins/sympy/
		doins -r data/TeXmacs/progs
	fi
}

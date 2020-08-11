# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 eutils virtualx

DESCRIPTION="Computer Algebra System in pure Python"
HOMEPAGE="https://sympy.org"
SRC_URI="https://github.com/sympy/sympy/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples imaging ipython latex mathml opengl pdf png pyglet symengine test texmacs theano"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/mpmath[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
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
	theano? ( dev-python/theano[${PYTHON_USEDEP}] )
"

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" setup.py test || die "Tests failed with ${EPYTHON}"
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

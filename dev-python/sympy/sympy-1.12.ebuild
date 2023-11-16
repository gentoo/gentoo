# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 virtualx

DESCRIPTION="Computer Algebra System in pure Python"
HOMEPAGE="
	https://www.sympy.org/
	https://github.com/sympy/sympy/
	https://pypi.org/project/sympy/
"
SRC_URI="
	https://github.com/sympy/sympy/archive/${P}.tar.gz -> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="aesara examples imaging ipython latex mathml opengl pdf png pyglet symengine texmacs"

RDEPEND="
	dev-python/mpmath[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	aesara? (
		$(python_gen_cond_dep '
			dev-python/aesara[${PYTHON_USEDEP}]
		' python3_{10..11})
	)
	imaging? ( dev-python/pillow[${PYTHON_USEDEP}] )
	ipython? ( dev-python/ipython[${PYTHON_USEDEP}] )
	latex? (
		virtual/latex-base
		dev-texlive/texlive-fontsextra
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl )
	)
	mathml? ( dev-python/lxml[${PYTHON_USEDEP}] )
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
	pyglet? ( dev-python/pyglet[${PYTHON_USEDEP}] )
	symengine? ( dev-python/symengine[${PYTHON_USEDEP}] )
	texmacs? ( app-office/texmacs )
"

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local color=True
	[[ ${NO_COLOR} ]] && color=False

	"${EPYTHON}" - <<-EOF || die -n "Tests failed with ${EPYTHON}"
		from sympy.testing.runtests import run_all_tests

		common = {
			"verbose": True,
			"colors": ${color},
			"force_colors": ${color},
			"blacklist": [
				# these require old version of antlr4
				"sympy/parsing/autolev/__init__.py",
				"sympy/parsing/latex/__init__.py",
				"sympy/parsing/tests/test_autolev.py",
				"sympy/parsing/tests/test_latex.py",
				# these fail on assertions inside LLVM
				"sympy/parsing/tests/test_c_parser.py",
				# hangs
				"sympy/printing/preview.py",
			],
		}

		run_all_tests(
			test_kwargs=common,
			doctest_kwargs=common,
		)
	EOF
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

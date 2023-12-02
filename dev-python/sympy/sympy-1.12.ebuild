# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

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
KEYWORDS="amd64 ~arm arm64 ~loong ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
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

EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${P}-py312.patch"
)

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# require old version of antlr4
		sympy/parsing/tests/test_autolev.py
		sympy/parsing/tests/test_latex.py
		# crash due to assertions in sys-devel/llvm[debug]
		sympy/parsing/tests/test_c_parser.py

		# TODO: pytest?
		sympy/solvers/ode/tests/test_systems.py::test_linear_3eq_order1_type4_long_check
		sympy/solvers/ode/tests/test_systems.py::test_linear_3eq_order1_type4_long_dsolve_dotprodsimp

		# either very slow or hanging
		sympy/solvers/ode/tests/test_systems.py::test_linear_new_order1_type2_de_lorentz_slow_check
		sympy/integrals/tests/test_failing_integrals.py::test_issue_15227
		sympy/matrices/tests/test_matrices.py::test_pinv_rank_deficient_when_diagonalization_fails
		sympy/solvers/ode/tests/test_systems.py::test_nonlinear_3eq_order1_type1
		sympy/solvers/ode/tests/test_systems.py::test_nonlinear_3eq_order1_type3
	)

	case ${EPYTHON} in
		pypy3)
			if has_version "<dev-python/pypy3_10-exe-7.3.13_p2" ||
				has_version "<dev-python/pypy3_10-exe-bin-7.3.13_p2"
			then
				EPYTEST_DESELECT+=(
					# https://foss.heptapod.net/pypy/pypy/-/issues/4032
					sympy/tensor/array/tests/test_array_comprehension.py::test_arraycomprehensionmap
				)
			fi
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	nonfatal epytest --veryquickcheck ||
		die -n "Tests failed with ${EPYTHON}"
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

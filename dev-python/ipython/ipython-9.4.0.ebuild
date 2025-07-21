# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )
PYTHON_REQ_USE='readline(+),sqlite,threads(+)'

inherit distutils-r1 optfeature pypi virtualx

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="
	https://ipython.org/
	https://github.com/ipython/ipython/
	https://pypi.org/project/ipython/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="examples notebook nbconvert qt5 +smp test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/ipython-pygments-lexers[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.16[${PYTHON_USEDEP}]
	dev-python/matplotlib-inline[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.3[${PYTHON_USEDEP}]
	>=dev-python/prompt-toolkit-3.0.41[${PYTHON_USEDEP}]
	<dev-python/prompt-toolkit-3.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.4.0[${PYTHON_USEDEP}]
	dev-python/stack-data[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.13.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.11)
"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		app-text/dvipng[truetype]
		>=dev-python/ipykernel-5.1.0[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.9[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
		dev-python/matplotlib-inline[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pickleshare[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

RDEPEND+="
	nbconvert? (
		dev-python/nbconvert[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	$(python_gen_cond_dep '
		qt5? ( dev-python/qtconsole[${PYTHON_USEDEP}] )
	' 'python*')
	$(python_gen_cond_dep '
		notebook? (
			dev-python/notebook[${PYTHON_USEDEP}]
			dev-python/ipywidgets[${PYTHON_USEDEP}]
			dev-python/widgetsnbextension[${PYTHON_USEDEP}]
		)
	' 3.{11..12})
	smp? (
		>=dev-python/ipykernel-5.1.0[${PYTHON_USEDEP}]
		>=dev-python/ipyparallel-6.2.3[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# Rename the test directory to reduce sys.path pollution
	# https://github.com/ipython/ipython/issues/12892
	mv IPython/extensions/{,ipython_}tests || die

	distutils-r1_python_prepare_all
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local -x IPYTHON_TESTING_TIMEOUT_SCALE=20
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3*)
			EPYTEST_DESELECT+=(
				# https://github.com/ipython/ipython/issues/14244
				tests/test_display.py::TestAudioDataWithoutNumpy
			)
			;;
	esac

	# nonfatal implied by virtx
	nonfatal epytest || die "Tests failed on ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# Create ipythonX.Y symlinks.
	# TODO:
	# 1. do we want them for pypy? No.  pypy has no numpy
	# 2. handle it in the eclass instead (use _python_ln_rel).
	# With pypy not an option the dosym becomes unconditional
	dosym ../lib/python-exec/${EPYTHON}/ipython \
		/usr/bin/ipython${EPYTHON#python}
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	optfeature "code formatting" dev-python/black
	optfeature "sympyprinting" dev-python/sympy
	optfeature "cythonmagic" dev-python/cython
	optfeature "%lprun magic command" dev-python/line-profiler
	optfeature "%matplotlib magic command" dev-python/matplotlib-inline

	if use nbconvert; then
		if ! has_version virtual/pandoc ; then
			einfo "Node.js will be used to convert notebooks to other formats"
			einfo "like HTML. Support for that is still experimental. If you"
			einfo "encounter any problems, please use app-text/pandoc instead."
		fi
	fi
}

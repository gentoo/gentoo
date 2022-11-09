# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='readline,sqlite,threads(+)'

inherit distutils-r1 optfeature virtualx

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="https://ipython.org/ https://github.com/ipython/ipython/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc examples matplotlib notebook nbconvert qt5 +smp test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/backcall[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.16[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/matplotlib-inline[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.3[${PYTHON_USEDEP}]
	dev-python/pickleshare[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-2[${PYTHON_USEDEP}]
	<dev-python/prompt_toolkit-3.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.4.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/stack_data[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		app-text/dvipng[truetype]
		>=dev-python/ipykernel-5.1.0[${PYTHON_USEDEP}]
		dev-python/matplotlib-inline[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.19[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/ipykernel-5.1.0[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		>=dev-python/sphinx-2[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

RDEPEND+="
	nbconvert? (
		dev-python/nbconvert[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	notebook? (
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
		dev-python/widgetsnbextension[${PYTHON_USEDEP}]
	)
	qt5? ( dev-python/qtconsole[${PYTHON_USEDEP}] )
	smp? (
		>=dev-python/ipykernel-5.1.0[${PYTHON_USEDEP}]
		>=dev-python/ipyparallel-6.2.3[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}"/2.1.0-substitute-files.patch )

python_prepare_all() {
	# Remove out of date insource files
	#rm IPython/extensions/cythonmagic.py || die
	#rm IPython/extensions/rmagic.py || die

	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	# Rename the test directory to reduce sys.path pollution
	# https://github.com/ipython/ipython/issues/12892
	mv IPython/extensions/{,ipython_}tests || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html_noapi
		HTML_DOCS=( docs/build/html/. )
	fi
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local -x IPYTHON_TESTING_TIMEOUT_SCALE=20
	local EPYTEST_DESELECT=(
		# Internet
		IPython/core/display.py::IPython.core.display.Image.__init__
		# TODO: looks to be a regression due to a newer dep
		IPython/core/tests/test_oinspect.py::test_class_signature
		IPython/core/tests/test_oinspect.py::test_render_signature_long
		# TODO
		IPython/extensions/ipython_tests/test_autoreload.py::TestAutoreload::test_smoketest_aimport
		IPython/extensions/ipython_tests/test_autoreload.py::TestAutoreload::test_smoketest_autoreload
	)
	[[ ${EPYTHON} == python3.10 ]] && EPYTEST_DESELECT+=(
		# TODO
		IPython/core/tests/test_completer.py::TestCompleter::test_all_completions_dups
		IPython/core/tests/test_completer.py::TestCompleter::test_deduplicate_completions
	)
	# nonfatal implied by virtx
	nonfatal epytest || die "Tests failed with ${EPYTHON}"
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
	optfeature "%lprun magic command" dev-python/line_profiler
	optfeature "%mprun magic command" dev-python/memory_profiler

	if use nbconvert; then
		if ! has_version app-text/pandoc ; then
			einfo "Node.js will be used to convert notebooks to other formats"
			einfo "like HTML. Support for that is still experimental. If you"
			einfo "encounter any problems, please use app-text/pandoc instead."
		fi
	fi
}

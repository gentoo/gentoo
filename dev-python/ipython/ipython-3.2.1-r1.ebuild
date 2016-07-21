# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
PYTHON_REQ_USE='readline,sqlite,threads(+)'

inherit distutils-r1 eutils virtualx

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="http://ipython.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples matplotlib mongodb notebook nbconvert octave qt4 +smp test wxwidgets"

REQUIRED_USE="
	test? ( doc matplotlib mongodb notebook nbconvert octave qt4 wxwidgets )
	doc? ( mongodb )"

CDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/simplegeneric[${PYTHON_USEDEP}]
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	mongodb? ( <dev-python/pymongo-3[${PYTHON_USEDEP}] )
	octave? ( dev-python/oct2py[${PYTHON_USEDEP}] )
	smp? ( >=dev-python/pyzmq-13[${PYTHON_USEDEP}] )
	wxwidgets? ( $(python_gen_cond_dep 'dev-python/wxpython:*[${PYTHON_USEDEP}]' python2_7) )"
RDEPEND="${CDEPEND}
	notebook? (
		dev-libs/mathjax
		dev-python/jinja[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-2.0[${PYTHON_USEDEP}]
		>=dev-python/mistune-0.5[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-13[${PYTHON_USEDEP}]
		>=dev-python/terminado-0.3.3[${PYTHON_USEDEP}]
		>=www-servers/tornado-4.0[${PYTHON_USEDEP}]
	)
	nbconvert? (
		|| ( >=net-libs/nodejs-0.9.12 >=app-text/pandoc-1.12.1 )
		dev-python/jinja[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-2.0[${PYTHON_USEDEP}]
		>=dev-python/mistune-0.5[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	qt4? (
		|| (
			dev-python/PyQt4[${PYTHON_USEDEP},svg]
			dev-python/PyQt5[${PYTHON_USEDEP},svg]
			dev-python/pyside[${PYTHON_USEDEP},svg]
		)
		dev-python/pygments[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-13[${PYTHON_USEDEP}] )"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		app-text/dvipng
		dev-python/jinja[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=www-servers/tornado-4.0[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/cython[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/fabric[${PYTHON_USEDEP}]' python2_7)
		>=dev-python/jsonschema-2.0[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/rpy[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1[${PYTHON_USEDEP}]
		>=www-servers/tornado-4.0[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/2.1.0-substitute-files.patch
	"${FILESDIR}/${P}"-set-mime-type-on-files.patch
	"${FILESDIR}/${P}"-set-model-mimetype-even-when-content-False.patch
	"${FILESDIR}/${P}"-only-redirect-to-editor-for-text-documents.patch
	"${FILESDIR}/${P}"-Don-t-redirect-from-edit-to-files.patch
	)

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Remove out of date insource files
	rm IPython/extensions/rmagic.py || die

	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html_noapi
}

python_test() {
	distutils_install_for_testing
	# https://github.com/ipython/ipython/issues/8639
	# Failure of some modules only in python3.4 
	local fail
	run_tests() {
		pushd ${TEST_DIR} > /dev/null || die
		"${PYTHON}" -m IPython.testing.iptestcontroller --all || fail=1
		popd > /dev/null || die
	}
	VIRTUALX_COMMAND=run_tests virtualmake
	[[ ${fail} ]] && die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	use notebook && \
		ln -sf "${EPREFIX}/usr/share/mathjax" "${D}$(python_get_sitedir)/IPython/html/static/mathjax"

	# Create ipythonX.Y symlinks.
	# TODO:
	# 1. do we want them for pypy? No.  pypy has no numpy
	# 2. handle it in the eclass instead (use _python_ln_rel).
	# With pypy not an option the dosym becomes unconditional
	dosym ../lib/python-exec/${EPYTHON}/ipython \
		/usr/bin/ipython${EPYTHON#python}
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
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

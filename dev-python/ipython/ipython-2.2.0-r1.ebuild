# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )
PYTHON_REQ_USE='readline,sqlite'

inherit distutils-r1 virtualx

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="http://ipython.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

IUSE="doc examples matplotlib mongodb notebook nbconvert octave qt4 +smp test wxwidgets"

PY2_USEDEP=$(python_gen_usedep python2_7)
CDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/simplegeneric[${PYTHON_USEDEP}]
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	octave? ( dev-python/oct2py[${PYTHON_USEDEP}] )
	smp? ( >=dev-python/pyzmq-2.1.11[${PYTHON_USEDEP}] )
	wxwidgets? ( $(python_gen_cond_dep 'dev-python/wxpython:*[${PYTHON_USEDEP}]' python2_7) )"
RDEPEND="${CDEPEND}
	notebook? (
		>=www-servers/tornado-3.1[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-2.1.11[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-libs/mathjax
	)
	nbconvert? (
		>=app-text/pandoc-1.12.1
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
	)
	qt4? (
		|| (
			dev-python/PyQt4[${PYTHON_USEDEP}]
			dev-python/pyside[${PYTHON_USEDEP}]
		)
		dev-python/pygments[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-2.1.11[${PYTHON_USEDEP}] )"
DEPEND="${CDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PY2_USEDEP}]
	)
	doc? (
		dev-python/cython[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/fabric[${PYTHON_USEDEP}]' python2_7)
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/rpy[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=www-servers/tornado-3.1[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/2.1.0-substitute-files.patch
	"${FILESDIR}"/2.1.0-disable-tests.patch
	"${FILESDIR}"/${P}-login-backport.patch
	)

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Remove out of date insource files
	rm IPython/extensions/rmagic.py || die
	rm IPython/extensions/octavemagic.py || die

	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

src_test() {
	# virtualx has trouble with parallel runs.
	local DISTUTILS_NO_PARALLEL_BUILD=1
	distutils-r1_src_test
}

python_test() {
	distutils_install_for_testing
	local fail
	run_tests() {
		pushd ${TEST_DIR} > /dev/null
		"${PYTHON}" -m IPython.testing.iptestcontroller --all || fail=1
		popd > /dev/null
	}
	VIRTUALX_COMMAND=run_tests virtualmake
		[[ ${fail} ]] && die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	use notebook && dosym /usr/share/mathjax $(python_get_sitedir)/IPython/html/static/mathjax

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
	elog "To enable sympyprinting, it's required to emerge sympy"
	elog "To enable cythonmagic, it's required to emerge cython"
}

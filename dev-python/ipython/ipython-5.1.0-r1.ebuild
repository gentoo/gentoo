# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE='readline,sqlite,threads(+)'

inherit distutils-r1 eutils

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="http://ipython.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc examples matplotlib mongodb notebook nbconvert qt4 +smp test wxwidgets"

REQUIRED_USE="
	test? ( doc matplotlib mongodb notebook nbconvert qt4 wxwidgets )
	doc? ( mongodb )"

CDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pickleshare[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/simplegeneric[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-1.0.3[${PYTHON_USEDEP}]
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	mongodb? ( <dev-python/pymongo-3[${PYTHON_USEDEP}] )
	wxwidgets? ( $(python_gen_cond_dep 'dev-python/wxpython:*[${PYTHON_USEDEP}]' python2_7) )"

RDEPEND="${CDEPEND}
	virtual/python-pathlib[${PYTHON_USEDEP}]
	notebook? (
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
	)
	nbconvert? ( dev-python/nbconvert[${PYTHON_USEDEP}] )"
DEPEND="${CDEPEND}
	>=dev-python/setuptools-18.5[${PYTHON_USEDEP}]
	$(python_gen_cond_dep \
		'dev-python/backports-shutil_get_terminal_size[${PYTHON_USEDEP}]' 'python2*')
	test? (
		app-text/dvipng
		dev-python/jinja[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
		>=www-servers/tornado-4.0[${PYTHON_USEDEP}]
		x11-base/xorg-server[xvfb]
	)
	doc? (
		dev-python/cython[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/fabric[${PYTHON_USEDEP}]' python2_7)
		>=dev-python/jsonschema-2.0[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
		dev-python/rpy[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=www-servers/tornado-4.0[${PYTHON_USEDEP}]
	)"

PDEPEND="
	qt4? ( dev-python/qtconsole )
	smp? ( dev-python/ipyparallel[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/2.1.0-substitute-files.patch
	)

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Remove out of date insource files
	rm IPython/extensions/cythonmagic.py || die
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

	pushd ${TEST_DIR} > /dev/null || die
	"${PYTHON}" -m IPython.testing.iptestcontroller --all || die
	popd > /dev/null || die
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
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
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

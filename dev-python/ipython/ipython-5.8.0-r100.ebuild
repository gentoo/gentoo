# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='readline,sqlite,threads(+)'

inherit distutils-r1 eutils virtualx

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="http://ipython.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"

# This is a special transitional ebuild for users and revdeps that need python2
# It comes without docs or scripts because otherwise, we conflict with the :0
# slot.
SLOT="py2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="matplotlib notebook nbconvert qt5 +smp test wxwidgets"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.10.0[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pickleshare[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-1.0.4[${PYTHON_USEDEP}]
	<dev-python/prompt_toolkit-2[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/simplegeneric[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	wxwidgets? ( dev-python/wxpython:*[${PYTHON_USEDEP}] )
"

RDEPEND="${CDEPEND}
	virtual/python-pathlib[${PYTHON_USEDEP}]
	nbconvert? ( dev-python/nbconvert[${PYTHON_USEDEP}] )
	!<dev-python/ipython-6:0"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/backports-shutil_get_terminal_size[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)"

PDEPEND="
	notebook? (
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
	)
	qt5? ( dev-python/qtconsole[${PYTHON_USEDEP}] )
	smp? ( dev-python/ipyparallel[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/2.1.0-substitute-files.patch )

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Remove out of date insource files
	rm IPython/extensions/cythonmagic.py || die
	rm IPython/extensions/rmagic.py || die

	distutils-r1_python_prepare_all
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	distutils_install_for_testing
	pushd "${TEST_DIR}" >/dev/null || die
	"${TEST_DIR}"/scripts/iptest || die
	popd >/dev/null || die
}

python_install_all() {
	distutils-r1_python_install_all

	# Remove script symlinks and man page to avoid collisions with slot 0
	rm "${D}/usr/bin/iptest"
	rm "${D}/usr/bin/ipython"
	rm "${D}/usr/share/man/man1/ipython.*"
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

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 toolchain-funcs elisp-common

DESCRIPTION="A Python to C compiler"
HOMEPAGE="https://cython.org https://pypi.org/project/Cython/
	https://github.com/cython/cython"
SRC_URI="https://github.com/cython/cython/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="emacs test"
RESTRICT="!test? ( test )"

RDEPEND="
	emacs? ( >=app-editors/emacs-23.1:* )
"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' \
			'python3*')
	)"

PATCHES=(
	"${FILESDIR}/cython-0.29.14-sphinx-update.patch"
)

SITEFILE=50cython-gentoo.el

distutils_enable_sphinx docs

python_compile() {
	if ! python_is_python3; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		local CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	fi

	# Python gets confused when it is in sys.path before build.
	local -x PYTHONPATH=

	distutils-r1_python_compile
}

python_compile_all() {
	use emacs && elisp-compile Tools/cython-mode.el
}

python_test() {
	tc-export CC
	# https://github.com/cython/cython/issues/1911
	local -x CFLAGS="${CFLAGS} -fno-strict-overflow"
	"${PYTHON}" runtests.py -vv --work-dir "${BUILD_DIR}"/tests \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES.rst README.rst ToDo.txt USAGE.txt )
	distutils-r1_python_install_all

	if use emacs; then
		elisp-install ${PN} Tools/cython-mode.*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )
PYTHON_REQ_USE="threads(+)"

inherit flag-o-matic distutils-r1 toolchain-funcs

DESCRIPTION="Lightweight and super-fast messaging library built on top of the ZeroMQ library"
HOMEPAGE="http://www.zeromq.org/bindings:python https://pypi.org/project/pyzmq/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=net-libs/zeromq-4.2.2-r2:=[drafts]
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/cffi:=[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/gevent[${PYTHON_USEDEP}]' python2_7)
"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/unittest2[${PYTHON_USEDEP}]' -2)
		>=www-servers/tornado-5.0.2[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/${P}-test_message.patch )

python_prepare_all() {
	# Prevent un-needed download during build
	sed -e "/'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	distutils-r1_python_prepare_all
}

python_configure_all() {
	tc-export CC
	append-cppflags -DZMQ_BUILD_DRAFT_API=1
}

python_compile_all() {
	use doc && emake -C docs html
}

python_compile() {
	esetup.py cython --force
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	${EPYTHON} -m pytest -v "${BUILD_DIR}/lib" || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}

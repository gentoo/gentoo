# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE="threads(+)"

inherit flag-o-matic distutils-r1 toolchain-funcs

EGIT_COMMIT="dd4dac055152d47c829034224cdecf594c7b3f12"
DESCRIPTION="Lightweight and super-fast messaging library built on top of the ZeroMQ library"
HOMEPAGE="
	https://www.zeromq.org/bindings:python
	https://pypi.org/project/pyzmq/
	https://github.com/zeromq/pyzmq/"
SRC_URI="
	https://github.com/zeromq/pyzmq/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="+draft"

DEPEND="
	>=net-libs/zeromq-4.2.2-r2:=[drafts]
"
RDEPEND="${DEPEND}
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/cffi:=[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		>=www-servers/tornado-5.0.2[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/pyzmq-19.0.0-tests.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	"dev-python/numpydoc"

python_prepare_all() {
	# probably broken with new numpy
	sed -i -e 's:test_buffer_numpy:_&:' zmq/tests/test_message.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	tc-export CC
	append-cppflags -DZMQ_BUILD_DRAFT_API=$(usex draft '1' '0')
}

python_compile() {
	esetup.py cython --force
	distutils-r1_python_compile
}

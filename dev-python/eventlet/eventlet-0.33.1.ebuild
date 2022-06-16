# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Highly concurrent networking library"
HOMEPAGE="
	https://pypi.org/project/eventlet/
	https://github.com/eventlet/eventlet/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="examples"

RDEPEND="
	>=dev-python/dnspython-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	virtual/python-greenlet[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/eventlet-0.25.1-tests.patch"
	"${FILESDIR}/eventlet-0.30.0-tests-socket.patch"
	"${FILESDIR}/eventlet-0.30.2-test-timeout.patch"
)

distutils_enable_tests nose

src_prepare() {
	# increase timeout - #791748
	sed -e '/eventlet.sleep/s/0.1/5.0/' -i tests/isolated/patcher_fork_after_monkey_patch.py || die

	distutils-r1_src_prepare
}

python_test() {
	unset PYTHONPATH
	export TMPDIR="${T}"
	nosetests -v -x || die
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}

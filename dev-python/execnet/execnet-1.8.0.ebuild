# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Rapid multi-Python deployment"
HOMEPAGE="https://codespeak.net/execnet/
	https://pypi.org/project/execnet/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-macos"

RDEPEND=">=dev-python/apipkg-1.4[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_sphinx doc
distutils_enable_tests pytest

python_prepare_all() {
	sed -i -r 's:(,[[:space:]]*|)"eventlet":: ; s:(,[[:space:]]*|)"gevent"(,|)::' \
		testing/conftest.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local deselect=(
		# needs python2.7 with apipkg?
		'testing/test_termination.py::test_close_initiating_remote_no_error[python2.7]'
		# tries to run python2
		testing/test_channel.py::TestStringCoerce::test_3to2
		testing/test_gateway.py::TestStringCoerce::test_3to2
		# does not like Gentoo defaults
		testing/test_gateway.py::TestPopenGateway::test_dont_write_bytecode
		# almost all tests call py2, not worth filtering for the rest
		testing/test_serializer.py
	)

	pytest -vv ${deselect[@]/#/--deselect } ||
		die "Tests failed with ${EPYTHON}"
}

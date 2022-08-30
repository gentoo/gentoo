# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A high performance, concurrent HTTP client library for Python using gevent"
HOMEPAGE="
	https://github.com/geventhttpclient/geventhttpclient/
	https://pypi.org/project/geventhttpclient/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ppc ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	app-arch/brotli[python,${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/gevent[events(+),${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# Avoid ModuleNotFoundError for tests we skip later
	sed -e '/^import dpkt.ssl/d' -i src/geventhttpclient/tests/test_ssl.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# These SNI tests require dpkt which is not in the tree
		src/geventhttpclient/tests/test_ssl.py::test_implicit_sni_from_host_in_ssl
		src/geventhttpclient/tests/test_ssl.py::test_implicit_sni_from_header_in_ssl
		src/geventhttpclient/tests/test_ssl.py::test_explicit_sni_in_ssl
	)
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# Skip tests which require internet access
	epytest -m "not online"
}

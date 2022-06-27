# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A high performance, concurrent HTTP client library for Python using gevent"
HOMEPAGE="https://github.com/gwik/geventhttpclient"
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
	sed -i '/^import dpkt.ssl/d' src/geventhttpclient/tests/test_ssl.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# These SNI tests require dpkt which is not in the tree
		src/geventhttpclient/tests/test_ssl.py::test_implicit_sni_from_host_in_ssl
		src/geventhttpclient/tests/test_ssl.py::test_implicit_sni_from_header_in_ssl
		src/geventhttpclient/tests/test_ssl.py::test_explicit_sni_in_ssl
	)
	# Append to sys.path to avoid ImportError
	# https://bugs.gentoo.org/667758
	# Skip tests which require internet access
	epytest --import-mode=append -m "not online"
}

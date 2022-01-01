# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="A high performance, concurrent HTTP client library for Python using gevent"
HOMEPAGE="https://github.com/gwik/geventhttpclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/gevent[${PYTHON_USEDEP}]
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
	local skipped_tests=(
		# These SNI tests require dpkt which is not in the tree
		src/geventhttpclient/tests/test_ssl.py::test_implicit_sni_from_host_in_ssl
		src/geventhttpclient/tests/test_ssl.py::test_implicit_sni_from_header_in_ssl
		src/geventhttpclient/tests/test_ssl.py::test_explicit_sni_in_ssl
	)
	# Append to sys.path to avoid ImportError
	# https://bugs.gentoo.org/667758
	# Skip tests which require internet access
	pytest --import-mode=append -vv ${skipped_tests[@]/#/--deselect } \
		-m "not online" || die "Tests failed with ${EPYTHON}"
}

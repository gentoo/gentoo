# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit distutils-r1

DESCRIPTION="A high performance, concurrent HTTP client library for Python using gevent"
HOMEPAGE="https://github.com/gwik/geventhttpclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/gevent[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# Skip SNI tests which require dpkt
	sed -i '/^import dpkt.ssl/d' src/geventhttpclient/tests/test_ssl.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local skipped_tests=(
		# Require dpkg
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

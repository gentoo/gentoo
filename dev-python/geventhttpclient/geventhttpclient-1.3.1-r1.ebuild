# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="A high performance, concurrent HTTP client library for Python using gevent"
HOMEPAGE="https://github.com/gwik/geventhttpclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/gevent[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# https://github.com/gwik/geventhttpclient/pull/82
	rm -r src/geventhttpclient/tests/__pycache__ || die
	distutils-r1_python_prepare_all
}

python_test() {
	# Ignore tests which require network access
	# Append to sys.path to avoid ImportError
	# https://bugs.gentoo.org/667758
	# Skip a test that fails with Python > 3.7
	# https://github.com/gwik/geventhttpclient/issues/119
	pytest --import-mode=append -vv src/geventhttpclient/tests --ignore \
		src/geventhttpclient/tests/test_client.py --deselect \
		src/geventhttpclient/tests/test_headers.py::test_cookielib_compatibility \
		|| die "Tests failed with ${EPYTHON}"
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi toolchain-funcs

DESCRIPTION="Python bindings for curl/libcurl"
HOMEPAGE="
	http://pycurl.io/
	https://github.com/pycurl/pycurl/
	https://pypi.org/project/pycurl/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="curl_ssl_gnutls curl_ssl_nss +curl_ssl_openssl examples ssl"

# Depend on a curl with curl_ssl_* USE flags.
# libcurl must not be using an ssl backend we do not support.
# If the libcurl ssl backend changes pycurl should be recompiled.
# If curl uses gnutls, depend on at least gnutls 2.11.0 so that pycurl
# does not need to initialize gcrypt threading and we do not need to
# explicitly link to libgcrypt.
DEPEND="
	>=net-misc/curl-7.25.0-r1:=[ssl=]
	ssl? (
		net-misc/curl[curl_ssl_gnutls(-)=,curl_ssl_nss(-)=,curl_ssl_openssl(-)=,-curl_ssl_axtls(-),-curl_ssl_cyassl(-)]
		curl_ssl_gnutls? ( >=net-libs/gnutls-2.11.0:= )
		curl_ssl_openssl? ( dev-libs/openssl:= )
	)
"

RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		>=dev-python/bottle-0.12.7[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		net-misc/curl[curl_ssl_gnutls(-)=,curl_ssl_nss(-)=,curl_ssl_openssl(-)=,-curl_ssl_axtls(-),-curl_ssl_cyassl(-),http2]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# docs installed into the wrong directory
	sed -e "/setup_args\['data_files'\] = /d" -i setup.py || die
	# TODO
	sed -e 's:test_socks5_gssapi_nec_setopt:_&:' \
		-i tests/option_constants_test.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	# Override faulty detection in setup.py, bug #510974.
	export PYCURL_SSL_LIBRARY=${CURL_SSL}
}

src_test() {
	emake -C tests/fake-curl/libcurl CC="$(tc-getCC)"

	distutils-r1_src_test
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_DESELECT=(
		# refcounting tests are unreliable
		tests/memory_mgmt_test.py::MemoryMgmtTest::test_readdata_refcounting
		tests/memory_mgmt_test.py::MemoryMgmtTest::test_writedata_refcounting
		tests/memory_mgmt_test.py::MemoryMgmtTest::test_writeheader_refcounting
	)

	epytest -p flaky tests
}

python_install_all() {
	local HTML_DOCS=( doc/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}

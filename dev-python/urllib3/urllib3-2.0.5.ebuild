# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_TESTED=( python3_{10..12} pypy3 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="
	https://github.com/urllib3/urllib3/
	https://pypi.org/project/urllib3/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="brotli test zstd"
RESTRICT="!test? ( test )"

# [secure] extra is deprecated and slated for removal, we don't need it:
# https://github.com/urllib3/urllib3/issues/2680
RDEPEND="
	>=dev-python/PySocks-1.5.8[${PYTHON_USEDEP}]
	<dev-python/PySocks-2.0[${PYTHON_USEDEP}]
	brotli? ( >=dev-python/brotlicffi-0.8.0[${PYTHON_USEDEP}] )
	zstd? ( >=dev-python/zstandard-0.18.0[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		$(python_gen_cond_dep "
			${RDEPEND}
			dev-python/brotlicffi[\${PYTHON_USEDEP}]
			dev-python/freezegun[\${PYTHON_USEDEP}]
			dev-python/pytest[\${PYTHON_USEDEP}]
			>=dev-python/tornado-4.2.1[\${PYTHON_USEDEP}]
			>=dev-python/trustme-0.5.3[\${PYTHON_USEDEP}]
			>=dev-python/zstandard-0.18.0[\${PYTHON_USEDEP}]
		" "${PYTHON_TESTED[@]}")
	)
"

src_prepare() {
	# upstream considers 0.5 s to be "long" for a timeout
	# we get tons of test failures on *fast* systems because of that
	sed -i -e '/LONG_TIMEOUT/s:0.5:5:' test/__init__.py || die
	distutils-r1_src_prepare
}

python_test() {
	local -x CI=1
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_DESELECT=(
		# take forever
		test/contrib/test_pyopenssl.py::TestSocketSSL::test_requesting_large_resources_via_ssl
		test/with_dummyserver/test_socketlevel.py::TestSSL::test_requesting_large_resources_via_ssl
		# stupid test, next bump please verify if they fixed it
		test/test_poolmanager.py::TestPoolManager::test_deprecated_no_scheme
		# fails with newer secure SSL configuration, which removes TLS 1.1
		test/contrib/test_pyopenssl.py::TestHTTPS_TLSv1::test_verify_none_and_good_fingerprint
		test/contrib/test_pyopenssl.py::TestHTTPS_TLSv1_1::test_verify_none_and_good_fingerprint
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1::test_verify_none_and_good_fingerprint
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_1::test_verify_none_and_good_fingerprint
		# TODO: timeouts
		test/contrib/test_pyopenssl.py::TestSocketClosing::test_timeout_errors_cause_retries
		test/with_dummyserver/test_socketlevel.py::TestSocketClosing::test_timeout_errors_cause_retries
		# warnings, sigh
		test/with_dummyserver/test_connectionpool.py::TestConnectionPool::test_request_chunked_is_deprecated
	)

	# plugins make tests slower, and more fragile
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

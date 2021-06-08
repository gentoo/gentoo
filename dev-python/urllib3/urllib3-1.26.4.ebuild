# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="https://github.com/urllib3/urllib3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="brotli test"
RESTRICT="!test? ( test )"

# dev-python/{pyopenssl,cryptography,idna,certifi} are optional runtime
# dependencies. Do not add them to RDEPEND. They should be unnecessary with
# modern versions of python (>= 3.2).
RDEPEND="
	>=dev-python/PySocks-1.5.8[${PYTHON_USEDEP}]
	<dev-python/PySocks-2.0[${PYTHON_USEDEP}]
	brotli? ( dev-python/brotlicffi[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		$(python_gen_cond_dep "
			${RDEPEND}
			dev-python/brotlicffi[\${PYTHON_USEDEP}]
			dev-python/mock[\${PYTHON_USEDEP}]
			dev-python/pytest[\${PYTHON_USEDEP}]
			dev-python/pytest-freezegun[\${PYTHON_USEDEP}]
			>=dev-python/trustme-0.5.3[\${PYTHON_USEDEP}]
			>=www-servers/tornado-4.2.1[\${PYTHON_USEDEP}]
		" python3_{6,7,8,9})
	)
"

PATCHES=(
	"${FILESDIR}/${P}-test-ssltransport.patch"
)

python_prepare_all() {
	# tests failing if 'localhost.' cannot be resolved
	sed -e 's:test_dotted_fqdn:_&:' \
		-i test/with_dummyserver/test_https.py || die
	sed -e 's:test_request_host_header_ignores_fqdn_dot:_&:' \
		-i test/with_dummyserver/test_socketlevel.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x CI=1
	# FIXME: get tornado ported
	[[ ${EPYTHON} == python3* ]] || continue
	# tests skipped for now
	[[ ${EPYTHON} == python3.10 ]] && continue

	local deselect=(
		# TODO?
		test/with_dummyserver/test_socketlevel.py::TestSocketClosing::test_timeout_errors_cause_retries
	)
	[[ "${EPYTHON}" == python3.10 ]] && deselect+=(
		# Fail because they rely on warnings and there are new deprecation warnings in 3.10
		test/with_dummyserver/test_https.py::TestHTTPS::test_verified
		test/with_dummyserver/test_https.py::TestHTTPS::test_verified_with_context
		test/with_dummyserver/test_https.py::TestHTTPS::test_context_combines_with_ca_certs
		test/with_dummyserver/test_https.py::TestHTTPS::test_ca_dir_verified
		test/with_dummyserver/test_https.py::TestHTTPS::test_ssl_correct_system_time
		test/with_dummyserver/test_https.py::TestHTTPS::test_ssl_wrong_system_time
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_2::test_verified
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_2::test_verified_with_context
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_2::test_context_combines_with_ca_certs
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_2::test_ca_dir_verified
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_2::test_ssl_correct_system_time
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_2::test_ssl_wrong_system_time
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_2::test_default_tls_version_deprecations
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_2::test_no_tls_version_deprecation_with_ssl_version
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_2::test_no_tls_version_deprecation_with_ssl_context
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_3::test_verified
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_3::test_verified_with_context
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_3::test_context_combines_with_ca_certs
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_3::test_ca_dir_verified
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_3::test_ssl_correct_system_time
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_3::test_ssl_wrong_system_time
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_3::test_default_tls_version_deprecations
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_3::test_no_tls_version_deprecation_with_ssl_version
		test/with_dummyserver/test_https.py::TestHTTPS_TLSv1_3::test_no_tls_version_deprecation_with_ssl_context
	)

	epytest ${deselect[@]/#/--deselect }
}

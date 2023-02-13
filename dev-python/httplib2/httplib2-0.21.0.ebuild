# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A comprehensive HTTP client library"
HOMEPAGE="
	https://pypi.org/project/httplib2/
	https://github.com/httplib2/httplib2/
"
SRC_URI="
	https://github.com/httplib2/httplib2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	app-misc/ca-certificates
	dev-python/pyparsing[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-libs/openssl
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${PN}-0.12.1-use-system-cacerts.patch )

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	# cryptography dep is entirely optional, and has a good fallback
	sed -i -e 's:from cryptography.*:pass:' tests/__init__.py || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# broken by using system certificates
		tests/test_cacerts_from_env.py::test_certs_file_from_builtin
		tests/test_cacerts_from_env.py::test_certs_file_from_environment
		tests/test_cacerts_from_env.py::test_with_certifi_removed_from_modules

		# broken by new PySocks, probably
		tests/test_proxy.py::test_server_not_found_error_is_raised_for_invalid_hostname
		tests/test_proxy.py::test_socks5_auth

		# broken by recerting (TODO)
		tests/test_https.py::test_min_tls_version
		tests/test_https.py::test_max_tls_version

		# new cryptography or openssl-3?
		tests/test_https.py::test_client_cert_password_verified
	)

	# tests in python* are replaced by tests/
	# upstream fails at cleaning up stuff
	epytest tests
}

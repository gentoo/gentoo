# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="A comprehensive HTTP client library"
HOMEPAGE="https://pypi.org/project/httplib2/"
SRC_URI="
	https://github.com/httplib2/httplib2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	app-misc/ca-certificates
	dev-python/pyparsing[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-libs/openssl
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${PN}-0.12.1-use-system-cacerts.patch )

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	distutils-r1_src_prepare
}

src_test() {
	# the bundled certificates use weak MDs
	pushd tests/tls >/dev/null || die
	../../script/generate-tls || die
	popd >/dev/null || die

	# recerting increases serial numbers
	sed -e 's:E2AA6A96D1BF1AEC:E2AA6A96D1BF1AEF:' \
		-e 's:E2AA6A96D1BF1AED:E2AA6A96D1BF1AF0:' \
		-i tests/test_https.py || die

	distutils-r1_src_test
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
	)

	# tests in python* are replaced by tests/
	# upstream fails at cleaning up stuff
	epytest tests
}

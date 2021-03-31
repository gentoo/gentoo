# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="A comprehensive HTTP client library"
HOMEPAGE="https://pypi.org/project/httplib2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	app-misc/ca-certificates
	dev-python/pyparsing[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${PN}-0.12.1-use-system-cacerts.patch )

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	local deselect=(
		# broken by using system certificates
		tests/test_cacerts_from_env.py::test_certs_file_from_builtin
		tests/test_cacerts_from_env.py::test_certs_file_from_environment
		tests/test_cacerts_from_env.py::test_with_certifi_removed_from_modules

		# broken by new PySocks, probably
		tests/test_proxy.py::test_server_not_found_error_is_raised_for_invalid_hostname
		tests/test_proxy.py::test_socks5_auth
	)

	# tests in python* are replaced by tests/
	# upstream fails at cleaning up stuff
	epytest ${deselect[@]/#/--deselect } tests
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python FTP server library"
HOMEPAGE="https://github.com/giampaolo/pyftpdlib https://pypi.org/project/pyftpdlib/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="examples ssl"

RDEPEND="
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

python_test() {
	cd "${BUILD_DIR}"/lib || die

	# These tests fail when passing additional options to pytest
	# so we need to run them separately and not pass any args to pytest
	pytest ${PN}/test/test_misc.py || die "Tests failed with ${EPYTHON}"
	# Some of these tests tend to fail
	local EPYTEST_DESELECT=(
		# Those tests are run separately
		pyftpdlib/test/test_misc.py
		# https://github.com/giampaolo/pyftpdlib/issues/471
		# https://bugs.gentoo.org/636410
		pyftpdlib/test/test_functional.py::TestCallbacks::test_on_incomplete_file_received
		# https://github.com/giampaolo/pyftpdlib/issues/512
		# https://bugs.gentoo.org/701146
		pyftpdlib/test/test_functional_ssl.py::TestFtpStoreDataTLSMixin::test_rest_on_stor
		pyftpdlib/test/test_functional_ssl.py::TestFtpStoreDataTLSMixin::test_stor_ascii
		# https://github.com/giampaolo/pyftpdlib/issues/513
		# https://bugs.gentoo.org/676232
		pyftpdlib/test/test_servers.py::TestFtpAuthentication::test_anon_auth
		# https://github.com/giampaolo/pyftpdlib/issues/513
		# https://bugs.gentoo.org/702578
		pyftpdlib/test/test_servers.py::TestFtpAuthentication::test_auth_failed
		# https://github.com/giampaolo/pyftpdlib/issues/543
		# https://bugs.gentoo.org/758686
		pyftpdlib/test/test_functional.py::ThreadedFTPTests::test_idle_timeout
		pyftpdlib/test/test_functional.py::ThreadedFTPTests::test_stou_max_tries
		# https://github.com/giampaolo/pyftpdlib/issues/550
		# https://bugs.gentoo.org/759040
		pyftpdlib/test/test_functional.py::TestConfigurableOptions::test_masquerade_address
		pyftpdlib/test/test_functional.py::TestConfigurableOptions::test_masquerade_address_map
		pyftpdlib/test/test_functional_ssl.py::TestConfigurableOptions::test_masquerade_address
		pyftpdlib/test/test_functional_ssl.py::TestConfigurableOptions::test_masquerade_address_map
		pyftpdlib/test/test_functional_ssl.py::TestConfigurableOptionsTLSMixin::test_masquerade_address
		pyftpdlib/test/test_functional_ssl.py::TestConfigurableOptionsTLSMixin::test_masquerade_address_map
	)
	# Tests fail with TZ=GMT, see https://bugs.gentoo.org/666623
	local -x TZ=UTC+1
	# Skips some shoddy tests plus increases timeouts
	local -x TRAVIS=1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}

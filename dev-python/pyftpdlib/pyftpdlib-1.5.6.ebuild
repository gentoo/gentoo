# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Python FTP server library"
HOMEPAGE="https://github.com/giampaolo/pyftpdlib https://pypi.org/project/pyftpdlib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="examples ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	dev-python/pysendfile[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

python_test() {
	# These tests fail when passing additional options to pytest
	# so we need to run them separately and not pass any args to pytest
	pytest ${PN}/test/test_misc.py || die "Tests failed with ${EPYTHON}"
	# Some of these tests tend to fail
	local skipped_tests=(
		# https://github.com/giampaolo/pyftpdlib/issues/470
		# https://bugs.gentoo.org/659108
		pyftpdlib/test/test_functional_ssl.py::TestTimeouts::test_idle_data_timeout2
		pyftpdlib/test/test_functional_ssl.py::TestTimeoutsTLSMixin::test_idle_data_timeout2
		# https://github.com/giampaolo/pyftpdlib/issues/471
		# https://bugs.gentoo.org/636410
		pyftpdlib/test/test_functional.py::TestCallbacks::test_on_incomplete_file_received
		# https://github.com/giampaolo/pyftpdlib/issues/466
		# https://bugs.gentoo.org/659786
		pyftpdlib/test/test_functional_ssl.py::TestFtpListingCmdsTLSMixin::test_nlst
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
	)
	# Tests fail with TZ=GMT, see https://bugs.gentoo.org/666623
	TZ=UTC+1 pytest -vv \
		--ignore ${PN}/test/test_misc.py ${skipped_tests[@]/#/--deselect } \
			|| die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] && \
		[[ ${PYTHON_TARGETS} == *python2_7* ]] && \
		! has_version dev-python/pysendfile ; then
		elog "dev-python/pysendfile is not installed"
		elog "It can considerably speed up file transfers for Python 2"
	fi
}

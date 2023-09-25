# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python FTP server library"
HOMEPAGE="
	https://github.com/giampaolo/pyftpdlib/
	https://pypi.org/project/pyftpdlib/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
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
	rm -rf pyftpdlib || die
	# Some of these tests tend to fail
	local EPYTEST_DESELECT=(
		# fail because they process sys.argv and expect program args
		# rather than pytest args, sigh
		test/test_misc.py
		# TODO
		test/test_functional_ssl.py::TestFtpListingCmdsTLSMixin::test_nlst
	)
	# Tests fail with TZ=GMT, see https://bugs.gentoo.org/666623
	local -x TZ=UTC+1
	# Skips some shoddy tests plus increases timeouts
	local -x TRAVIS=1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest --pyargs pyftpdlib
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}

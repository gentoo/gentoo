# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A PyTest plugin which provides an FTP fixture for your tests"
HOMEPAGE="
	https://github.com/oz123/pytest-localftpserver/
	https://pypi.org/project/pytest-localftpserver/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/pyftpdlib[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_IGNORE=(
	# These tests require python wget module
	tests/test_pytest_localftpserver.py
	tests/test_pytest_localftpserver_TLS.py
	tests/test_pytest_localftpserver_with_env_var.py
)

distutils_enable_tests pytest
